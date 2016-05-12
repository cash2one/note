
msfunc = msfunc or {}

--布局适配方案
--@iType 适配类型 （详情参照ms.layoutType.exact_fit定义）
--@node 适配对象 
function msfunc.layoutTypeHandle(iType, node)
    if node ~= nil then
        local nodeSize = node:getContentSize()
        local screenSize = cc.Director:getInstance():getVisibleSize()
        if iType == ms.layoutType.exact_fit then
            node:setScale(screenSize.width / nodeSize.width, screenSize.height / nodeSize.height)
        elseif iType == ms.layoutType.no_border then
            local fScreenRate = screenSize.width / screenSize.height
            local fNodeRate = nodeSize.width / nodeSize.height
            if fScreenRate > fNodeRate then
                local widthRate = screenSize.width / nodeSize.width
                node:setScale(widthRate, widthRate)
            else
                local heightRate = screenSize.height / nodeSize.height
                node:setScale(heightRate, heightRate)
            end
        elseif iType == ms.layoutType.show_all then
            local fScreenRate = screenSize.width / screenSize.height
            local fNodeRate = nodeSize.width / nodeSize.height
            if fScreenRate < fNodeRate then
                local widthRate = screenSize.width / nodeSize.width
                node:setScale(widthRate, widthRate)
            else
                local heightRate = screenSize.height / nodeSize.height
                node:setScale(heightRate, heightRate)
            end
        elseif iType == ms.layoutType.fixed_width then
            local widthRate = screenSize.width / nodeSize.width
            node:setScale(widthRate, widthRate)
        elseif iType == ms.layoutType.fixed_height then
            local heightRate = screenSize.height / nodeSize.height
            node:setScale(heightRate, heightRate)
        elseif iType == ms.layoutType.size_full then
            node:setContentSize(screenSize)
        end
    end
end

