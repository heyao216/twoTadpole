import(".TwoTadpole")
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

local controller = getGameController()
function GameScene:ctor()
    bg = display.newSprite("res/commonBg.jpg")
    bg:setAnchorPoint(ccp(0, 0))
    bg:setScaleY(display.height / bg:getContentSize().height)
    gameLayer = display.newLayer()
    gameLayer:addChild(bg)
    self:addChild(gameLayer)
    gameLayer:addTouchEventListener(onLayerTouch)
    gameLayer:setTouchEnabled(true)
    gameLayer:addChild(controller)
    controller:setPosition(ccp(DESIGN_SIZE_WIDTH  / 2, 100))
    local cheackPoint = require("scripts/app/scenes/CheackPoint1"):new()
    cheackPoint:init(gameLayer)
    cheackPoint:start()
end

function GameScene:onEnter()

end

function onLayerTouch(event , x , y , prevX , prevY)
    --print(event , x , y , prevX , prevY)
    if event == "began" then
        if x > DESIGN_SIZE_WIDTH  / 2 then
            controller:right()
        else
            controller:left()
        end
    elseif event == "ended" then
        controller:stop()
    end
    return true
end

function GameScene:onExit()
end

return GameScene
