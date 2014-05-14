require("scripts/app/scenes/ShapeFactory")
local CheackPoint1 = class("CheackPoint1")
local scheduler = require("framework.scheduler")
local color = ccc4f(1.0, 1.0, 1.0, 1.0)
function CheackPoint1:ctor()
	self.list = {}
end

function CheackPoint1:init(node)
	self.container = node
end

function CheackPoint1:start()
	CheackPoint1.timer = scheduler.scheduleGlobal(function () self:addObject() end, 1)
	CheackPoint1.updateHandler = scheduler.scheduleUpdateGlobal(function () self:update() end)
end

function CheackPoint1:stop()
	scheduler.unscheduleGlobal(CheackPoint1.timer)
	scheduler.unscheduleGlobal(CheackPoint1.updateHandler)
end

function CheackPoint1:reset()
	stop()
	for i = 1 , #self.list do
		local shape = self.list[i]
		shape:removeFromParentAndCleanup(true)
	end
	self.list = {}
end

function CheackPoint1:addObject()
	local shape
	if math.random() > 0.5 then
	 	shape = createRectangle(100, 30, color)
	else
	 	shape = createRectangle(50, 50, color)
	end
	shape:setPosition(ccp(math.random(50 , DESIGN_SIZE_WIDTH - 80), CONFIG_SCREEN_HEIGHT))
	self.container:addChild(shape)
	table.insert(self.list , shape)
end

function CheackPoint1:update()
	for i = 1 , #self.list do
		local shape = self.list[i]
		if shape ~= nil then
			shape:setPositionY(shape:getPositionY() - 5)
			if shape:getPositionY() < 0 then
				table.remove(self.list , i)
				shape:removeFromParentAndCleanup(true)
			end
		end
	end
end

return CheackPoint1