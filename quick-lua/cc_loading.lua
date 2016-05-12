
-- 在后台加载一个图像，加载完成后输出消息
display.addImageAsync("hello.png", function()
    print("load hello.png completed")
end)




-- 判断平台类型， 用于音效加载
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

	if (cc.PLATFORM_OS_IPHONE == targetPlatform) 
		or (cc.PLATFORM_OS_IPAD == targetPlatform)
        or (cc.PLATFORM_OS_WINDOWS == targetPlatform) 
        or (cc.PLATFORM_OS_ANDROID == targetPlatform)
           or (cc.PLATFORM_OS_MAC  == targetPlatform) then