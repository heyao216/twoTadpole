local CUR_MODULE = ...
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

function GameScene:ctor()
    bg = display.newSprite("res/bg.jpg")
    local imgS = display.width/bg:getContentSize().width;
    bg:setScale(imgS)
    bg:setAnchorPoint(ccp(0, 0))
    bg:setPosition(ccp(0,0))
    --bg:setScaleY(display.height / bg:getContentSize().height)
    gameLayer = display.newLayer()
    gameLayer:addChild(bg)
    self:addChild(gameLayer)
    gameLayer:setTouchEnabled(true)
    local world = CCPhysicsWorld:create(0 , 0)
    local controller = import(".TwoTadpole", CUR_MODULE):new()
    controller:init(gameLayer , world)
    controller:start()
    gameLayer:addChild(world)
end

function GameScene:onEnter()

end

function GameScene:onExit()
end

return GameScene
