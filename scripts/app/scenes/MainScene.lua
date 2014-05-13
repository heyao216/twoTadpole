
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)
end

function MainScene:onEnter()
    if device.platform == "android" then
        -- avoid unmeant back
        self:performWithDelay(function()
            -- keypad layer, for android
            local layer = display.newLayer()
            layer:addKeypadEventListener(function(event)
                if event == "back" then app.exit() end
            end)
            self:addChild(layer)
            layer:setTouchEnabled(true)
            layer:addTouchEventListener(onLayerTouch)
            layer:setKeypadEnabled(true)
        end, 0.5)
    end
end

function onLayerTouch(event , x , y ,prevX , prevY)
    print(event , x , y , prevX , prevY)
end

function MainScene:onExit()
end

return MainScene
