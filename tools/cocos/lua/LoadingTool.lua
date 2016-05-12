
local LoadingTool = class("LoadingTool")

function LoadingTool:ctor()
	self:init()
end

function LoadingTool:init()
    self.m_funcFinish = nil
    self.m_funcProgress = nil
    self.m_iImageTotalCount = 0
    self.m_iImageLoaded = 0
    self.m_tbImageData = {}
    self.m_tbBackgroundSoundData = {}
    self.m_tbEffectSoundData = {}
    self.m_tbDragonbonesData = {}
    math.randomseed(math.random(0xffffff) + os.time()) 
    self.m_perValue = math.random(90, 100)
end

--设置加载进度回调，func的参数为进度
function LoadingTool:setProgressCallBack(func)
	self.m_funcProgress = func
end

--设置加载完成回调
function LoadingTool:setFinishCallBack(func)
	self.m_funcFinish = func
end

--添加图片路径
function LoadingTool:addLoadImage(szFile)
	table.insert(self.m_tbImageData, szFile)
end

--添加地图ID
function LoadingTool:addLoadMap(iMapID)
	--table.insert(self.m_tbImageData, szFile)
end

--添加背景声音
function LoadingTool:addLoadBackgroundSound(szFile)
	table.insert(self.m_tbBackgroundSoundData, szFile)
end

--添加特效声音
function LoadingTool:addLoadEffectSound(szFile)
	table.insert(self.m_tbEffectSoundData, szFile)
end

--添加龙骨
function LoadingTool:addLoadDragonBones(szDBName)
	self:addLoadImage(string.format("charactor/%s/texture.png", szDBName))
	table.insert(self.m_tbDragonbonesData, szDBName)
end


function LoadingTool:startLoad()
	self:onLoadProgress(0)
    self.m_iImageTotalCount = table.getn(self.m_tbImageData)
	if self.m_iImageTotalCount > 0 then 
		self.m_iImageLoaded = 0
		for _, szFile in ipairs(self.m_tbImageData) do
			display.addImageAsync(szFile, handler(self, self.onImageAsyncFinish))
		end
	else
		self:onLoadFinish()
	end
end

---------------------------------------------------------
--以下是私有
---------------------------------------------------------

--每张图片加载结束之后的回调
function LoadingTool:onImageAsyncFinish()
	self.m_iImageLoaded = self.m_iImageLoaded + 1
	if self.m_iImageLoaded >= self.m_iImageTotalCount then
		self:onLoadFinish()
	else
		self:onLoadProgress(self.m_perValue * self.m_iImageLoaded / self.m_iImageTotalCount)
	end
end

--设置进度
function LoadingTool:onLoadProgress(fPer)
	if self.m_funcProgress ~= nil then
		self.m_funcProgress(fPer)
	end
end

function LoadingTool:onLoadFinish()
	self:dealWithUnAsyncData()
	self:onLoadProgress(100)
	if self.m_funcFinish ~= nil then
		self.m_funcFinish()
	end
	self:init()
end

function LoadingTool:dealWithUnAsyncData()
	for _, szFile in ipairs(self.m_tbBackgroundSoundData) do
		audio.preloadMusic(szFile)
	end
	for _, szFile in ipairs(self.m_tbEffectSoundData) do
		audio.preloadSound(szFile)
	end
	--龙骨
	local factory = db.DBCCFactory:getInstance()
	if factory ~= nil then
		for _, szFile in ipairs(self.m_tbDragonbonesData) do
			if factory:getDragonBonesData(szFile) == nil then
				factory:loadDragonBonesData(string.format("charactor/%s/skeleton.xml", szFile), szFile)
				factory:loadTextureAtlas(string.format("charactor/%s/texture.xml", szFile), szFile)
			end
		end
	end
end

return LoadingTool
