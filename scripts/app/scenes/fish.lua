local fish = class("fish")
--初始化
function fish:init(container)

	self.container = container

	--finImg = display.newSprite("#fish_tail.png") --鱼翅
	self.fin = display.newSprite("#fish_tail.png")
	--self.fin:addChild(finImg)
	--self.fin:setAnchorPoint(CCPoint(0 , 0))	
	self.fin:setPositionY(-16)
	
	self.head = display.newSprite("#fish_head.png")   --头部

	container:addChild(self.fin)
	container:addChild(self.head)

	self:onUpdate()
end

--开始
function fish:start()
	self.head:scheduleUpdate(handler(self, self.onUpdate), 0)
	self.finStatus = -1
	self.fin:setScale(0.6)
	self:playFinMotion()
end

--停止
function fish:stop()
	self.head:unscheduleUpdate()
end


--逐帧函数
function fish:onUpdate()
	headRotation = self.head:getRotation()
	self.fin:setRotation(headRotation)

	headX , headY = self.head:getPosition()
	self.fin:setPosition(headX , headY - 16)
end

function fish:playFinMotion()
	finScale = self.fin:getScale()

	if self.finStatus == -1 then
		transition.scaleTo(self.fin, {scale = 0.75, time = 1.2 , onComplete = function ()
			self:playFinMotion()
		end})
	end

	if self.finStatus == 1 then
		transition.scaleTo(self.fin, {scale = 0.6, time = 1.2 , onComplete = function ()
			self:playFinMotion()
		end})
	end
	
	self.finStatus = self.finStatus * -1
end

--获取需绑定的node
function fish:getBindNode()
	return self.head
end

return fish