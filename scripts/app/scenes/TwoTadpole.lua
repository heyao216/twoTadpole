local CUR_MODULE = ...
scheduler = require("framework.scheduler")
import("...lib.ChipmunkUtils")
import("...lib.tween")
local fish = import(".fish")
local TwoTadpole = class("TwoTadpole")
local circle_radius = 120
local rotate_speed = 3
local CENTER_X = CONFIG_SCREEN_WIDTH   / 2
local CENTER_Y = 150
function TwoTadpole:ctor()
	self.curAngle = 0
	self.physics = import("..pedatas.fruits" , CUR_MODULE).physicsData(1)
	self.score = ui.newTTFLabel({text = "得分:0" , size = 30 , color = ccc3(255, 255, 255) , align = ui.TEXT_ALIGN_LEFT , valign = ui.TEXT_VALIGN_TOP})
	self.score:setAnchorPoint(ccp(0, 1))
	display.addSpriteFramesWithFile(GAME_DATA , GAME_IMG)
end

--初始化控制器
function TwoTadpole:init(layer , world)
	self.world = world
	self.layer = layer
	self.container = display.newBatchNode(GAME_IMG)
	self.score:setPosition(ccp(0, CONFIG_SCREEN_HEIGHT))
	self.layer:addChild(self.score)
	--调试
	--self.worldDebug = world:createDebugNode()
    --self.layer:addChild(self.worldDebug)
	self.layer:addChild(self.container)
	self.fish1 = fish:new()	
	self.fish2 = fish:new()
	self.fish1:init(self.container)
	self.fish2:init(self.container)
	self.body1 = createBody(self.physics:get("fish_head"), world)
	self.body2 = createBody(self.physics:get("fish_head"), world)
	self.body1:bind(self.fish1:getBindNode())
	self.body2:bind(self.fish2:getBindNode())
	self.cheackPoint = import(".CheackPoint1", CUR_MODULE):new()
	self.cheackPoint:init(self.container , world)
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
	self:updateScores(0)
	self.touches = 0
	self.touchHandler = handler(self, self.onLayerTouch)
	gameLayer:addTouchEventListener(self.touchHandler)
	self.fish1:start()
	self.fish2:start()
	self.world:start()
	self.cheackPoint:start()
	self.world:addCollisionScriptListener(handler(self , self.onCollision), 2, 1)
	self.world:addCollisionScriptListener(handler(self , self.onEateStarFish), 2, 3)
	self:setAngle(self.curAngle , 0)
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
		self:updateScores(0)
	end
	return true
end

--碰撞处理 碰到海星  吃掉
function TwoTadpole:onEateStarFish(phase , event)
	--print("吃掉")
	if phase == "begin" then
		self.cheackPoint:removeBody(event:getBody2())
		self:updateScores(self.currentScores + 1)
	end
	return true
end

--触摸处理
function TwoTadpole:onLayerTouch(event , x , y)
	if event == "began" then
		self.touches = self.touches + 1
        if x > DESIGN_SIZE_WIDTH  / 2 then
            self:right()
        else
            self:left()
        end
    elseif event == "ended" then
    	self.touches = self.touches - 1
    	if self.touches == 0 then
    		self:stopRotate()
    	end
    end
    return true
end

--左触摸
function TwoTadpole:left()
	--print("left")
	if self.updateHandler ~= nil then
		scheduler.unscheduleGlobal(self.updateHandler)
	end
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle + rotate_speed , -1)end)
end

--右触摸
function TwoTadpole:right()
	--print("right")
	if self.updateHandler ~= nil then
		scheduler.unscheduleGlobal(self.updateHandler)
	end
	self.updateHandler = scheduler.scheduleUpdateGlobal(function ()self:setAngle(self.curAngle - rotate_speed , 1)end)
end

--停止旋转
function TwoTadpole:stopRotate()
	--print("stop")
	if self.updateHandler ~= nil then
		scheduler.unscheduleGlobal(self.updateHandler)
	end
	local bodyAngle1 = self.body1:getRotation()
	local bodyAngle2 = self.body2:getRotation()
	local angle1 , angle2 = 180 , 180
	if bodyAngle1< 0 then
		angle1 = -180
	end
	if bodyAngle2< 0 then
		angle2 = -180
	end
	local frames1 = math.ceil(math.abs(angle1 - bodyAngle1) / 10)
	local frames2 = math.ceil(math.abs(angle2 - bodyAngle2) / 10)
	if frames1 ~= 0 then
		tween.rotateTo(self.body1 , angle1 , frames1)
	end
	if frames2 ~= 0 then
		tween.rotateTo(self.body2 , angle2 , frames2)
	end
end

--更新分数
function TwoTadpole:updateScores(scores)
	self.currentScores = scores
	self.score:setString("得分:"..self.currentScores)
end

return TwoTadpole