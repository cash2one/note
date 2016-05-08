




--------------------------------------------------------------
--  widget点击事件
--  1. 无法获取到触控坐标
--------------------------------------------------------------

btnPlay:setTouchEnabled(true)
btnPlay:addTouchEventListener(function (target, evt)
    -- target的值是
    -- btnPlay本身

    -- evt的值是
    -- ccui.TouchEventType.began
    -- ccui.TouchEventType.moved
    -- ccui.TouchEventType.ended
    -- ccui.TouchEventType.canceled

    if evt == ccui.TouchEventType.began then 
        print('began')
        return true
    elseif evt== ccui.TouchEventType.moved then 
        print('moved')
    end
end)


--------------------------------------------------------------
--  node点击事件
--  1. 可以获取到触控坐标
--------------------------------------------------------------

btnPlay:setTouchEnabled(true)
btnPlay:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    -- event.phase 的值是：
    -- cc.NODE_TOUCH_TARGETING_PHASE

    -- event.mode 的值是下列之一：
    -- cc.TOUCH_MODE_ONE_BY_ONE 单点触摸
    -- cc.TOUCH_MODE_ALL_AT_ONCE 多点触摸

    -- event.name 的值是下列之一：
    -- began 触摸开始
    -- moved 触摸点移动
    -- ended 触摸结束
    -- cancelled 触摸被取消

    -- 如果是单点触摸：
    -- event.x, event.y 是触摸点位置
    -- event.prevX, event.prevY 是触摸点之前的位置

    -- 如果是多点触摸：
    -- event.points 包含了所有触摸点的信息
    -- event.points = {point, point, ...}
    -- 每一个触摸点的值包含：
    -- point.x, point.y 触摸点的当前位置
    -- point.prevX, point.prevY 触摸点之前的位置
    -- point.id 触摸点 id，用于确定触摸点的变化

	if event.name == "began" then
		-- 在单点触摸模式下：在触摸事件开始时，必须返回 true
		-- 返回 true 表示响应本次触摸事件，并且接收后续状态更新
		print('began')
		return true
    end  
    dump(event)
end)






