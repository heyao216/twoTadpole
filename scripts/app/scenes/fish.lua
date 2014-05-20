local fish = class("fish")
--初始化
function fish:init(container)
	self.container = container
	self.head = display.newSprite("#fish_head.png")   --头部
	container:addChild(self.head)
end

--开始
function fish:start()
	self.head:scheduleUpdate(handler(self, self.onUpdate), 0)
end

--停止
function fish:stop()
	self.head:unscheduleUpdate()
end

--逐帧函数
function fish:onUpdate()
	--print("ok")	
end

--获取需绑定的node
function fish:getBindNode()
	return self.head
end

return fish