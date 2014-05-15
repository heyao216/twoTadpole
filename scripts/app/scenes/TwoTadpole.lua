local CUR_MODULE = ...
import("...lib.ChipmunkUtils")
local scheduler = require("framework.scheduler")
local controller
local cheackPoint
local TwoTadpole = class("TwoTadpole")
local circle_radius = 100
local rotate_speed = 5
local CENTER_X = CONFIG_SCREEN_WIDTH   / 2
local CENTER_Y = 150
function TwoTadpole:ctor()
	self.curAngle = 0
	self.physics = import("..pedatas.fruits" , CUR_MODULE).physicsData(1)
	display.addSpriteFramesWithFile(GAME_DATA , GAME_IMG)
end

--初始化控制器
function TwoTadpole:init(container , world)
	--debug
	--self.worldDebug = world:createDebugNode()
    --container:addChild(self.worldDebug)
	self.world = world
	self.container = container
	local tadpole1 = display.newSprite("#tadpole.png")
	local tadpole2 = display.newSprite("#tadpole.png")
	local physicsData = self.physics:get("tadpole")
	self.body1 = self.world:createCircleBody(0, 8 , 0, 0)
	self.body2 = self.world:createCircleBody(0, 8 , 0, 0)
	self.body1:setCollisionType(2)
	self.body2:setCollisionType(2)
	self.body1:bind(tadpole1)
	self.body2:bind(tadpole2)
	self.cheackPoint = import(".CheackPoint1", CUR_MODULE):new()
	self.cheackPoint:init(container , world)
	container:addChild(tadpole1)
	container:addChild(tadpole2)
	self:setAngle(self.curAngle)
end

--设置角度
function TwoTadpole:setAngle(angle)
	self.curAngle = angle
	self.body1:setPositionX(math.cos(ang2rad(angle))* circle_radius + CENTER_X)
	self.body1:setPositionY(math.sin(ang2rad(angle)) * circle_radius + CENTER_Y)
	self.body2:setPositionX(math.cos(ang2rad(angle + 180)) * circle_radius + CENTER_X)
	self.body2:setPositionY(math.sin(ang2rad(angle + 180)) * circle_radius + CENTER_Y)
end

--开始游戏
function TwoTadpole:start()
	self.touchHandler = handler(self, self.onLayerTouch)
	gameLayer:addTouchEventListener(self.touchHandler)
	self.world:start()
	self.cheackPoint:start()
	self.world:addCollisionScriptListener(handler(self , self.onCollision), 1, 2)
end

--停止游戏
function TwoTadpole:stop()
	if not self.touchHandler then
		gameLayer:removeTouchEventListener(self.touchHandler)
	end
	self.cheackPoint:stop()
	self.world:removeAllCollisionListeners()
	self.world:stop()
end

--碰撞处理
function TwoTadpole:onCollision(phase , event)
	print("collision")
	if phase == "begin" then
		self.cheackPoint:reset()
	end
	return true
end

--触摸处理
function TwoTadpole:onLayerTouch(event , x , y , prevX , prevY)
    --print(event , x , y , prevX , prevY)
    if event == "began" then
        if x > DESIGN_SIZE_WIDTH  / 2 then
            self:right()
        else
            self:left()
        end
    elseif event == "ended" then
        self:stopRotate()
    end
    return true
end

--左触摸
function TwoTadpole:left()
	--print("left")
	self.step = 2
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle + rotate_speed)end)
end
--右触摸
function TwoTadpole:right()
	--print("right")
	self.step = -2
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle - rotate_speed)end)
end

--停止旋转
function TwoTadpole:stopRotate()
	--print("stop")
	scheduler.unscheduleGlobal(self.updateHandler)
end

return TwoTadpole