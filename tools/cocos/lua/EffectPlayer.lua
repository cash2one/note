
local EffectPlayer = class("EffectPlayer", function()
    return cc.Node:create()
end)

--测试用例：
--require("app.component.EffectPlayer"):example():addTo(self)
function EffectPlayer:example()
	local effect = self.new("xinxin", "roott")
	effect:addActionEventListener(function(sender, event)
		if event.type == 8 then
			print("action event loop")
		elseif event.type == 7 then
			print("action event end")
			sender:removeSelf()
		end
	end)
	effect:addFrameEventListener(function(sender, event)
		print("frame event：" .. event.frameLabel)
	end)
	effect:playAction("IDLE1", 3)
	return effect
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


--特效初始化，调用new时传入
--szResource 资源名称（统一放在effect/目录下）
--szRoot 节点，（默认为"root" ，可以不填）
function EffectPlayer:ctor(szResource, szRoot)
	if szRoot == nil then
		szRoot = "root"
	end
	local factory = db.DBCCFactory:getInstance()
	if factory:getDragonBonesData(szResource) == nil then
		factory:loadDragonBonesData(string.format("effect/%s/skeleton.xml", szResource), szResource)
		factory:loadTextureAtlas(string.format("effect/%s/texture.xml", szResource), szResource)
	end
	local armature = factory:buildArmatureNode(szRoot, szResource)
	if armature == nil then
		print("Error: cant't find armature")
	else
		armature:addTo(self)
		self.m_armature = armature
	end
end

--播放动画
--@szActionName 动画名称
--@playTimes 循环次数（默认为资源上的循环次数，可以不填）
--@fadeInTime 淡入时间（可以不填）
--@duration 从duration时间开始播放，单位秒（可以不填）
function EffectPlayer:playAction(szActionName, playTimes, fadeInTime, duration)
	local animation = self:getAnimation()
	if animation ~= nil and animation:hasAnimation(szActionName) then
		if playTimes == nil then playTimes = -1 end
		if fadeInTime == nil then fadeInTime = -1 end
		if duration == nil then duration = -1 end
		animation:gotoAndPlay(szActionName, fadeInTime, duration, playTimes)
	else
		print("Error: can't find action")
	end
end

--停止播放
function EffectPlayer:stop()
	local animation = self:getAnimation()
	if animation ~= nil then
		animation:stop()
	end
end

--设置缩放时间（可加快、可变慢）
function EffectPlayer:setTimeScale(fScale)
	local animation = self:getAnimation()
	if animation ~= nil then
		animation:setTimeScale(fScale)
	end
end

--获得缩放时间（可加快、可变慢）
function EffectPlayer:getTimeScale()
	local animation = self:getAnimation()
	if animation ~= nil then
		return animation:getTimeScale()
	end
	return 1
end

--获得动作
function EffectPlayer:getAnimation()
	local armature = self.m_armature
	if armature ~= nil then
		return armature:getAnimation()
	end
	return nil
end

---------------------------------------------------------------------------------
-- 【事件】参数event内容
-- db.DBCCArmature armature
-- db.DBCCArmatureNode armatureNode
-- int type				对应于dragonbones::EventData::EventType：
--							ANIMATION_FRAME_EVENT 1
--							COMPLETE              7   播放结束后调用，仅在n循环的第n次触发（非循环的第1次）
--							LOOP_COMPLETE         8   播放结束后调用，仅在n循环的前n-1次触发
-- string boneName		仅在帧事件中有效
-- string animationName 动作名称
-- string frameLabel	仅在帧事件中有效
-- bool isLastAnimation 是否最后1个动作
---------------------------------------------------------------------------------


--注册动画事件（单个动作结束、所有动作结束等）
--回调参数：(sender, event)
function EffectPlayer:addActionEventListener(func)
	local armature = self.m_armature
	if armature ~= nil then
		armature:registerAnimationEventHandler(function(event) func(self, event) end)
	end
end

--注册帧事件（资源上添加的事件）
--回调参数：(sender, event)
function EffectPlayer:addFrameEventListener(func)
	local armature = self.m_armature
	if armature ~= nil then
		armature:registerFrameEventHandler(function(event) func(self, event) end)
	end
end


return EffectPlayer
