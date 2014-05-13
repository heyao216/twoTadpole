require("scripts/lib/utils")
local scheduler = require("framework.scheduler")
local controller
local TwoTadpole = class("TwoTadpole", function ()
	return display.newNode()
end)
local circle_radius = 80
local rotate_speed = 5
function TwoTadpole:ctor()
	self.curAngle = 0
	self.tadpole1 = display.newSprite("res/tadpole.png")
	self.tadpole2 = display.newSprite("res/tadpole.png")
	self.tadpole1:setScale(1.5)
	self.tadpole2:setScale(1.5)
	self:addChild(self.tadpole1)
	self:addChild(self.tadpole2)
	self:setAngle(self.curAngle)
end

--设置角度
function TwoTadpole:setAngle(angle)
	self.curAngle = angle
	self.tadpole1:setPositionX(math.cos(ang2rad(angle))* circle_radius)
	self.tadpole1:setPositionY(math.sin(ang2rad(angle)) * circle_radius)
	self.tadpole2:setPositionX(math.cos(ang2rad(angle + 180)) * circle_radius)
	self.tadpole2:setPositionY(math.sin(ang2rad(angle + 180)) * circle_radius)
end

--左触摸
function TwoTadpole:left()
	print("left")
	self.step = 2
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle + rotate_speed)end)
end
--右触摸
function TwoTadpole:right()
	print("right")
	self.step = -2
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle - rotate_speed)end)
end

--停止旋转
function TwoTadpole:stop()
	print("stop")
	scheduler.unscheduleGlobal(self.updateHandler)
end

--单例游戏控制器
function getGameController()
	return controller or TwoTadpole:new()
end