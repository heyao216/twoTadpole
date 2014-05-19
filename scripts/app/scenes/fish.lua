local fish = class("fish")
--初始化
function fish:init(container)
	self.container = container
	self.head = display.newSprite("#fish_head.png")   --头部
	container:addChild(self.head)
end

--开始
function fish:start()
	self.updateHandler = scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))
end

--停止
function fish:stop()
	if self.updateHandler ~= nil then
		scheduler.unscheduleGlobal(self.updateHandler)
	end
end

--逐帧函数
function fish:onUpdate()
	print("ok")	
end

--获取需绑定的node
function fish:getBindNode()
	return self.head
end

return fish