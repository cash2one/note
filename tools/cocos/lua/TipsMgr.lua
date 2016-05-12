
TipsMgr = TipsMgr or {
	m_arrLineTipsMsg = {},
	m_bLineTextLock = false,
	m_arrLineText = {},
	m_DescTip = nil
}


--单行tips冒泡缓动
function TipsMgr:addLineTipsCenter(str)
	self:addLineTips(str, cc.p(display.cx, display.cy))
end

--单行tips冒泡缓动
function TipsMgr:addLineTips(str, pos)
	table.insert(self.m_arrLineTipsMsg, {m_szName = str, m_pos = pos})
	if self.m_bLineTextLock ~= true then
		self:nextLineTips()
	end
end

--描述tips
--@str 描述内容
--@pos 坐标（箭头位置）
--@size 自定义尺寸（可以不填）
--@isMask 是否遮罩，点击关闭（可以不填）
--@fDelayTimes 自动消失时间（可以不填）
function TipsMgr:addDescTip(str, pos, size, isMask, fDelayTimes)
	SceneMgr:addDescTip(self:initDescTips(str, pos, size, isMask, fDelayTimes))
end

function TipsMgr:removeDescTip()
	local desc = self.m_DescTip
	if desc ~= nil then
		desc:removeSelf()
	end
	self.m_DescTip = nil
end



---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
--   以下都是【私有】方法，外部不要调用
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

function TipsMgr:removeLineTips(text)
	local index = table.indexof(self.m_arrLineText, text, 0)
	text:removeSelf()
	table.remove(self.m_arrLineText, index)
end

function TipsMgr:nextLineTips()
	if table.getn(self.m_arrLineTipsMsg) == 0 then
		self.m_bLineTextLock = false;
		return;
	end
	self.m_bLineTextLock = true
	self:showLineTips()
end

function TipsMgr:getLineTipsText(szStr)
	local text
	if table.getn(self.m_arrLineText) >= 4 then
		text = self.m_arrLineText[1];
		text:stopAllActions();
		text:setLocalZOrder(-1);
		text:setLocalZOrder(0);
		text:setOpacity(255);
		text:setString(szStr);
		table.remove(self.m_arrLineText, 1)
	else
		text = cc.Label:createWithTTF(szStr, "ui/fonts/msyhbd.ttf", 30)
		text:setColor(cc.c3b(0, 255, 0));
		text:enableOutline(cc.c4b(0x0f, 0x0F, 0x0f, 0x9a), 1);
		text:setAnchorPoint(cc.p(0.5, 0.5));
		SceneMgr:addLineText(text);
	end
	table.insert(self.m_arrLineText, text)
	return text
end

function TipsMgr:showLineTips()
	local info = self.m_arrLineTipsMsg[1]
	table.remove(self.m_arrLineTipsMsg, 1)

	local text = self:getLineTipsText(info.m_szName);
	text:setPosition(info.m_pos);
	text:runAction(cc.Sequence:create(
		cc.MoveBy:create(0.2, cc.p(0, 20)),
		cc.CallFunc:create(handler(self,self.nextLineTips)),
		cc.MoveBy:create(0.6, cc.p(0, 70)),
		cc.FadeOut:create(0.8),
		cc.CallFunc:create(handler(self,self.removeLineTips, text))
	))
end


---------------------------------------------------------------------------------------------------------

function TipsMgr:initDescTips(str, pos, size, isMask, fDelayTimes)
	----------------tips----------------
	local desc = self.m_DescTip
	if desc == nil then
		desc = cc.Node:create()
		self.m_DescTip = desc
	end

	----------------组件----------------
	local bgScale9 = desc.m_Scale9BG
	if bgScale9 == nil then
		bgScale9 = ccui.Scale9Sprite:create("ui/common/scale_9_sprite.png", cc.rect(0, 0, 30, 30), cc.rect(14, 14, 1, 1))
		bgScale9:setAnchorPoint(cc.p(0.5, 0.5))
		desc:addChild(bgScale9, 1)
		desc.m_Scale9BG = bgScale9
	end
	local bgArrow = desc.m_ArrowBG
	if bgArrow == nil then
		bgArrow = cc.Sprite:create("ui/common/arrow.png");
		bgArrow:setAnchorPoint(cc.p(0.5, 0.5))
		desc:addChild(bgArrow, 2)
		desc.m_ArrowBG = bgArrow
	end
	local text = desc.m_DescText
	if text == nil then
		text = cc.Label:createWithTTF(str, "ui/fonts/msyhbd.ttf", 22)
		text:setColor(cc.c3b(0, 0, 0))
		--text:enableOutline(cc.c4b(0x0f, 0x0f, 0x0f, 0x9a), 1)
		text:setAnchorPoint(cc.p(0.5, 0.5))
		text:setMaxLineWidth(200)
		text:updateContent()
		bgScale9:addChild(text)
		desc.m_DescText = text
	else
		text:setString(str)
		text:updateContent()
	end

	----------------排版----------------
	local screenSize = cc.Director:getInstance():getVisibleSize()
	local textSize = text:getContentSize()
	local scale9Size = cc.size(textSize.width + 30, textSize.height + 30)
	if size ~= nil and size.width > textSize.width and size.height > textSize.height then
		scale9Size = size
	end
	local arrowSize = bgArrow:getContentSize()
	local arrowPos = cc.p(pos.x, pos.y + arrowSize.height / 2)
	local scale9Pos = cc.p(arrowPos.x , arrowPos.y + arrowSize.height / 2 + scale9Size.height / 2 - 5)
	if scale9Pos.y + scale9Size.height > screenSize.height then
		--距离上边缘 scale9Size.height/2 像素，保证体验 
		bgArrow:setScaleY(-1)
		arrowPos = cc.p(pos.x, pos.y - arrowSize.height / 2)
		scale9Pos = cc.p(arrowPos.x, arrowPos.y - arrowSize.height / 2 - scale9Size.height / 2 + 5)
	end
	bgScale9:setContentSize(scale9Size)
	bgArrow:setPosition(arrowPos);
	bgScale9:setPosition(scale9Pos);
	text:setPosition(cc.p(scale9Size.width / 2, scale9Size.height / 2))

	----------------功能----------------
	local mask = desc.m_MaskBG
	if mask == nil then
		if isMask == true then
			mask = ccui.ImageView:create("ui/common/mask.png")
			mask:setTouchEnabled(true)
			mask:setScale9Enabled(true)
			mask:setSwallowTouches(true)
			mask:setContentSize(screenSize)
			mask:setAnchorPoint(cc.p(0, 0))
			mask:setOpacity(25.5)
			mask:addTouchEventListener(handler(self, self.removeDescTip))
			desc:addChild(mask, 0)
			desc.m_MaskBG = mask
		end
	elseif isMask ~= true then
		mask:removeSelf()
		desc.m_MaskBG = nil
	end
	if fDelayTimes ~= nil and fDelayTimes > 0 then
		text:runAction(cc.Sequence:create(
			cc.DelayTime:create(fDelayTimes),
			cc.CallFunc:create(handler(self, self.removeDescTip))
		))
	end
	return desc
end


