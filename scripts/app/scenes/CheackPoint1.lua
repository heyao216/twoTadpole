local CUR_MODULE = ...
local CheackPoint1 = class("CheackPoint1")
local NAMES = {"starFish" , "goldFish" , "turtle" , "yellowFish" , "octopus"}
function CheackPoint1:ctor()
	self.list = {}
	self.physics = require("scripts/app/pedatas/fruits").physicsData(1)
end

--初始化  node:显示对象容器 , world:物理世界 
function CheackPoint1:init(node , world)
	self.container = node
	self.world = world
end

--开始
function CheackPoint1:start()
	CheackPoint1.timer = scheduler.scheduleGlobal(function () self:addObject() end, 1)
	CheackPoint1.updateHandler = scheduler.scheduleUpdateGlobal(function () self:update() end)
end

--停止
function CheackPoint1:stop()
	scheduler.unscheduleGlobal(CheackPoint1.timer)
	scheduler.unscheduleGlobal(CheackPoint1.updateHandler)
end

--重置
function CheackPoint1:reset()
	tween.killAll()
	local l = #self.list
	for i = l , 1 , -1 do
		local body = self.list[i]
		body:getNode():removeFromParentAndCleanup(true)
		self.world:removeBody(body, true)
	end
	self.list = {}
end

--移除一个障碍物
function CheackPoint1:removeBody(body)
	local l = #self.list
	for i = l , 1 , -1 do
		if body == self.list[i] then
			table.remove(self.list , i)
			--body:setScale(1.5)
			body:getNode():removeFromParentAndCleanup(true)
			self.world:removeBody(body)
		end
	end
end

--添加一个障碍物
function CheackPoint1:addObject()
	local name = NAMES[math.random(1 , #NAMES)]
	local obj = display.newSprite("#"..name..".png")
	self.container:addChild(obj)
	local physicsData = self.physics:get(name)
	local body = createBody(physicsData, self.world)
	body:bind(obj)
	body:setPosition(math.random(150 , CONFIG_SCREEN_WIDTH  - 150) , CONFIG_SCREEN_HEIGHT)
	table.insert(self.list , body)
end

--每帧更新
function CheackPoint1:update()
	local l = #self.list
	for i = l , 1 , -1 do
		local body = self.list[i]
		if body ~= nil then
			body:setPositionY(body:getPositionY() - 4)
			if body:getPositionY() < 0 then
				table.remove(self.list , i)
				body:getNode():removeFromParentAndCleanup(true)		--移除显示对象
				self.world:removeBody(body, true)					--移除物理对象并解绑
			end
		end
	end
end

return CheackPoint1