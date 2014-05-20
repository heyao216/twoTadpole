local CUR_MODULE = ...
scheduler = require("framework.scheduler")
import("...lib.ChipmunkUtils")
import("...lib.tween")
local fish = import(".fish")
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
	self.fish1 = fish:new()	
	self.fish2 = fish:new()
	self.fish1:init(container)
	self.fish2:init(container)
	self.body1 = createBody(self.physics:get("fish_head"), world)
	self.body2 = createBody(self.physics:get("fish_head"), world)
	self.body1:bind(self.fish1:getBindNode())
	self.body2:bind(self.fish2:getBindNode())
	self.cheackPoint = import(".CheackPoint1", CUR_MODULE):new()
	self.cheackPoint:init(container , world)
	self:setAngle(self.curAngle , 0)
end

--设置角度,方向  direction:1顺时针  direction:-1逆时针
function TwoTadpole:setAngle(angle , direction)
	self.curAngle = angle % 360
	--print("angle"..angle.." curAngle"..self.curAngle)
	self.body1:setPositionX(math.cos(ang2rad(angle))* circle_radius + CENTER_X)
	self.body1:setPositionY(math.sin(ang2rad(angle)) * circle_radius + CENTER_Y)
	self.body2:setPositionX(math.cos(ang2rad(angle + 180)) * circle_radius + CENTER_X)
	self.body2:setPositionY(math.sin(ang2rad(angle + 180)) * circle_radius + CENTER_Y)
	if direction == 0 then
		self.body1:setRotation(180)
		self.body2:setRotation(180)
	else
		local d1 = 180 - angle
		local d2 = 180 - angle
		if direction == -1 then
			d2 = d2 - 180
		else
			d1 = d1 - 180
		end
		self.body1:setRotation(d1)
		self.body2:setRotation(d2)
	end
end

--开始游戏
function TwoTadpole:start()
	self.touchHandler = handler(self, self.onLayerTouch)
	gameLayer:addTouchEventListener(self.touchHandler)
	self.fish1:start()
	self.fish2:start()
	self.world:start()
	self.cheackPoint:start()
	self.world:addCollisionScriptListener(handler(self , self.onCollision), 1, 2)
end

--停止游戏
function TwoTadpole:stop()
	if not self.touchHandler then
		gameLayer:removeTouchEventListener(self.touchHandler)
	end
	self.fish1.stop()
	self.fish2.stop()
	self.cheackPoint:stop()
	self.world:removeAllCollisionListeners()
	self.world:stop()
end

--碰撞处理
function TwoTadpole:onCollision(phase , event)
	--print("collision")
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
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle + rotate_speed , -1)end)
end

--右触摸
function TwoTadpole:right()
	--print("right")
	self.step = -2
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle - rotate_speed , 1)end)
end

--鱼转身
function TwoTadpole:rotateBody()
	-- body
end

--停止旋转
function TwoTadpole:stopRotate()
	--print("stop")
	scheduler.unscheduleGlobal(self.updateHandler)
	local angle1 , angle2 = 180 , 180
	if self.body1:getRotation() < 0 then
		angle1 = -180
	end
	if self.body2:getRotation() < 0 then
		angle2 = -180
	end
	tween.rotateTo(self.body1 , angle1 , 6)
	tween.rotateTo(self.body2 , angle2 , 6)
end

return TwoTadpole