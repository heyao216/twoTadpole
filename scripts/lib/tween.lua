--支持对非Node对象做动画,只要有相关方法如：getPosition,setPosition,getRotation,setRotation等
tween = {}
tween.tweenList = {}

function advance()
	if #tween.tweenList == 0 then
		scheduler.unscheduleGlobal(tween.updateHandler)
		tween.updateHandler = nil
	end
	for i = #tween.tweenList , 1 , -1 do
		if tween.tweenList[i] ~= nil then
			if tween.tweenList[i].isComplete then
				table.remove(tween.tweenList , i)
			else
				tween.tweenList[i].advance()
			end
		end
	end
end

--用指定帧数完成一个旋转动画
function tween.rotateTo(target , angle , frames)
	--print("angle:"..angle , "frames:"..frames)
	local t = {}
	t.target = target
	t.step = (angle - t.target:getRotation()) / frames
	t.restFrames = frames
	t.isComplete = false
	t.advance = function () rotateAdvance(t) end
	tween.addTween(t)
end

function rotateAdvance(t)
	if t.target == nil then
		t.isComplete = true
		return
	end
	local ang = t.target:getRotation() + t.step
	t.target:setRotation(ang)
	t.restFrames = t.restFrames - 1
	if t.restFrames == 0 then
		t.isComplete = true
	end
end

--添加一个动画
function tween.addTween(t)
	table.insert(tween.tweenList , t)
	if tween.updateHandler == nil then
		tween.updateHandler = scheduler.scheduleUpdateGlobal(advance)
	end
	--print("tween.tweenList "..#tween.tweenList)
end

--停止一个动画
function tween.killTarget(target)
	for i = 1 , #tween.tweenList do
		if tween.tweenList[i].target == target then
			tween.tweenList[i] = nil
		end
	end
end

--停止所有动画
function tween.killAll()
	tween.tweenList = {}
end





