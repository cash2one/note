

----------------------------------------------
--方向：
--self:setDirection(ccui.ScrollViewDir.vertical)
--self:setDirection(ccui.ScrollViewDir.horizontal)
--self:setDirection(ccui.ScrollViewDir.both)
--反弹：
--self:setBounceEnabled(true)
--背景图片
--self:setBackGroundImage("cocosui/green_edit.png")
--self:setBackGroundImageScale9Enabled(true)
----------------------------------------------

self:pushBackCustomItem(layout)

self:requestDoLayout()
self:jumpToTop()




------------------------------------------------------
-- 官方样例：
------------------------------------------------------


            local function listViewEvent(sender, eventType)
                if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
                    print("select child index = ",sender:getCurSelectedIndex())
                end
            end

            local function scrollViewEvent(sender, evenType)
                if evenType == ccui.ScrollviewEventType.scrollToBottom then
                    print("SCROLL_TO_BOTTOM")
                elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
                    print("SCROLL_TO_TOP")
                end
            end

            local listView = ccui.ListView:create()
            -- set list view ex direction
            listView:setDirection(ccui.ScrollViewDir.vertical)
            listView:setBounceEnabled(true)
            listView:setBackGroundImage("cocosui/green_edit.png")
            listView:setBackGroundImageScale9Enabled(true)
            listView:setContentSize(cc.size(240, 130))
            listView:setPosition(cc.p((widgetSize.width - backgroundSize.width) / 2.0 +
                                         (backgroundSize.width - listView:getContentSize().width) / 2.0,
                                     (widgetSize.height - backgroundSize.height) / 2.0 +
                                         (backgroundSize.height - listView:getContentSize().height) / 2.0))
            listView:addEventListener(listViewEvent)
            listView:addScrollViewEventListener(scrollViewEvent)
            self._uiLayer:addChild(listView)


            -- create model
            local default_button = ccui.Button:create("cocosui/backtotoppressed.png", "cocosui/backtotopnormal.png")
            default_button:setName("Title Button")

            local default_item = ccui.Layout:create()
            default_item:setTouchEnabled(true)
            default_item:setContentSize(default_button:getContentSize())
            default_button:setPosition(cc.p(default_item:getContentSize().width / 2.0, default_item:getContentSize().height / 2.0))
            default_item:addChild(default_button)

            --set model
            listView:setItemModel(default_item)

            --add default item
            local count = table.getn(array)
            for i = 1,math.floor(count / 4) do
                listView:pushBackDefaultItem()
            end
            --insert default item
            for i = 1,math.floor(count / 4) do
                listView:insertDefaultItem(0)
            end

            listView:removeAllChildren()

            local testSprite = cc.Sprite:create("cocosui/backtotoppressed.png")
            testSprite:setPosition(cc.p(200,200))
            listView:addChild(testSprite)

            --add custom item
            for i = 1,math.floor(count / 4) do
                local custom_button = ccui.Button:create("cocosui/button.png", "cocosui/buttonHighlighted.png")
                custom_button:setName("Title Button")
                custom_button:setScale9Enabled(true)
                custom_button:setContentSize(default_button:getContentSize())

                local custom_item = ccui.Layout:create()
                custom_item:setContentSize(custom_button:getContentSize())
                custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
                custom_item:addChild(custom_button)

                listView:addChild(custom_item)
            end

            --insert custom item
            local items = listView:getItems()
            local items_count = table.getn(items)
            for i = 1, math.floor(count / 4) do
                local custom_button = ccui.Button:create("cocosui/button.png", "cocosui/buttonHighlighted.png")
                custom_button:setName("Title Button")
                custom_button:setScale9Enabled(true)
                custom_button:setContentSize(default_button:getContentSize())

                local custom_item = ccui.Layout:create()
                custom_item:setContentSize(custom_button:getContentSize())
                custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
                custom_item:addChild(custom_button)
                custom_item:setTag(1)

                listView:insertCustomItem(custom_item, items_count)
            end

            -- set item data
            items_count = table.getn(listView:getItems())
            for i = 1,items_count do
                local item = listView:getItem(i - 1)
                local button = item:getChildByName("Title Button")
                local index = listView:getIndex(item)
                button:setTitleText(array[index + 1])
            end

            -- remove last item
            listView:removeChildByTag(1)

            -- remove item by index
            items_count = table.getn(listView:getItems())
            listView:removeItem(items_count - 1)

            -- set all items layout gravity
            listView:setGravity(ccui.ListViewGravity.centerVertical)

            --set items margin
            listView:setItemsMargin(2.0)


