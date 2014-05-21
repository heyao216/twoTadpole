local scheduler = require("framework.scheduler")                --加载定时器模块
local background1 = class("background1")
local bgBox = display.newLayer()                                --背景 main 盒子
local sceneW = display.width                                    --场景宽
local sceneH = display.height                                   --场景高
local sceneTileH  = 0                                           --平铺背景高度 
local sceneStep = 0                                             --场景移动计数
local sceneSpeed = 5                                            --场景移动速度
local sceneTimer = nil                                          --场景定时器
local sceneOrnStep = 0                                          --背景装饰品计数
local xyObject = {}                                             --背景装饰坐标保存
xyObject[0] = {}
xyObject[1] = {}
xyObject[2] = {}
display.addSpriteFramesWithFile("res/orn.plist", "res/orn.png")             --加载图片 and 数据
function background1:ctor()
    
end
function background1:init(lead)             --背景初始化加载
    self.lead = lead
    self:tilebg("res/bg.jpg")
    --bgBox:getChildren():objectAtIndex(1):addChild(background1:setOrn(1,10,0,sceneH+string.gsub(sceneTileH,"-",""),sceneH))
end
--停止背景滚动
function background1:stop()                
    scheduler.unscheduleGlobal(sceneTimer)
end
--开始背景滚动
function background1:start()        
    sceneTimer = scheduler.scheduleUpdateGlobal(function()
        if sceneStep < sceneTileH then
            sceneStep = 0
            --[[
            --print(sceneOrnStep,sceneTileH,sceneH+sceneTileH,bgBox:getChildrenCount(),sceneH)
            if sceneOrnStep < -(sceneH) then
                bgBox:getChildren():objectAtIndex(1):addChild(background1:setOrn(1,50,0,string.gsub(sceneOrnStep,"-","") + string.gsub(sceneOrnStep,"-","") + sceneH*2))
                sceneOrnStep = sceneOrnStep+sceneH
                xyObject[0],xyObject[1],xyObject[2] = {},{},{}
                --bgBox:getChildren():objectAtIndex(1):removeSelf()
                print(sceneOrnStep,sceneH,bgBox:getChildrenCount())
                bgBox:removeChild(bgBox:getChildren():objectAtIndex(1))
                bgBox:addChild(background1:setOrn(1,50,sceneH))
                --dump(bgBox)
            end
            bgBox:getChildren():objectAtIndex(1):setPositionY(sceneOrnStep)
            bgBox:getChildren():objectAtIndex(2):setPositionY(sceneOrnStep+sceneH)
            bgBox:getChildren():objectAtIndex(3):setPositionY(sceneOrnStep+sceneH*2)]]--
            --bgBox:getChildren():objectAtIndex(1):getChildren():objectAtIndex(0):removeSelf()
            --print(sceneOrnStep,sceneTileH,string.gsub(sceneOrnStep,"-",""),bgBox:getChildren():objectAtIndex(1):getChildrenCount())
            --print(tolua.cast(bgBox:getChildren():objectAtIndex(1), "CCNode"))
            --bgBox:removeChild(tolua.cast(bgBox:getChildren():objectAtIndex(1), "CCNode"))
            bgBox:getChildren():objectAtIndex(1):removeChild(tolua.cast(bgBox:getChildren():objectAtIndex(1):getChildren():objectAtIndex(0), "CCNode"))
            --print(bgBox:getChildren():objectAtIndex(1):getChildrenCount())
            sceneOrnStep = sceneOrnStep+sceneTileH
            bgBox:getChildren():objectAtIndex(1):setPositionY(sceneOrnStep)
            bgBox:getChildren():objectAtIndex(1):addChild(background1:setOrn(1,10,0,string.gsub(sceneOrnStep,"-",""),string.gsub(sceneOrnStep,"-","") + sceneH))
        end
        sceneStep = sceneStep-sceneSpeed
        bgBox:setPositionY(sceneStep)
        end,1)
end
--添加背景->装饰品
function background1:tilebg(img)
    local tileLayer = display.newSprite(img)
    local imgS = sceneW/tileLayer:getContentSize().width;
    tileLayer:setScale(imgS)
    tileLayer:setPosition(ccp(tileLayer:getContentSize().width/2*imgS, tileLayer:getContentSize().height/2*imgS))
    --[[
    local tile = display.newSprite(img)
    local tileW = tile:getContentSize().width
    local tileH = tile:getContentSize().height
    local tileS = sceneW/tileW/math.ceil(sceneW/tileW)
    local iw = tileW*tileS/2
    local ih = tileH*tileS/2
    sceneTileH = -ih
    while iw do
        if(iw > sceneW or tileW <= 0)then break end
        ih = tileH*tileS/2
        tileLayer:addChild(background1:addTile(iw,ih,tileS,img))
        while ih do
            if(ih > sceneH+320 or tileH <= 0)then break end
            tileLayer:addChild(background1:addTile(iw,ih,tileS,img))
            ih = ih+(tileH*tileS)/2
        end
        iw = iw+(tileW*tileS)
    end]]--
    --添加贴图

    bgBox:addChild(tileLayer)                       
    self.lead:addChild(bgBox)
    --添加装饰品
    --bgBox:addChild(background1:setOrn(0,1))
    --bgBox:addChild(background1:setOrn(1,50,sceneH))
    --bgBox:addChild(background1:setOrn(2,50,sceneH*2))
    --sceneOrnStep = sceneTileH
end
--返回一小块平铺贴图节点
function background1:addTile(iw,ih,s,img)
    local bg = display.newSprite(img)
    bg:setPosition(ccp(iw,ih))
    bg:setScale(s)
    return bg
end

--创建N个装饰品
function background1:setOrn (o,c,y,h,h2)
    if not c then return end
    local tileOrn = display.newLayer()
    for i=1,c do
        tileOrn:addChild(background1:randomOrn(o,i,h,h2))
    end
    tileOrn:setPositionY(y or 0)
    return tileOrn
end

--返回随机装饰品位置->大小->旋转角度
function background1:randomOrn (o,i,h,h2)
    --print(math.random()*(h or (sceneH + 1)))
    local orn = display.newSprite("#orn_00"..math.ceil(math.random()*46)..".png")
    local randomS = (math.random()*100 + 30)/orn:getContentSize().width
    --print(randomX,randomY)
    orn:setScale(randomS)
    orn:setRotation((math.random()*360))
    if type(h) ~= "nil"  then
        randomY = math.random()*h + h2
    else
        randomY = math.random()*sceneH + 1
    end
    randomX = math.random()*sceneW + 1
    --randomX,randomY = background1:randomCoordinate(o,randomS*orn:getContentSize().width,randomS*orn:getContentSize().height)
    orn:setPosition(ccp(randomX,randomY))
    local maxX = randomX+(randomS*orn:getContentSize().width)
    local maxY = randomY+(randomS*orn:getContentSize().height)
    --print(maxY,h2,h)
    xyObject[o][i] = {randomX,maxX,randomY,maxY}
    return orn
end
--装饰品随机坐标生成
function background1:randomCoordinate(o,w,h)
    local randomX = math.random()*sceneW + 1
    local randomY = math.random()*sceneH + 1
    i = 1
    while i do
        if type(xyObject[o][i]) == "nil" then break end
        if randomX > xyObject[o][i][1] and randomX < xyObject[o][i][2] and
            randomY > xyObject[o][i][3] and randomY < xyObject[o][i][4] then
            --background1:randomCoordinate(o)
            return background1:randomXY(o,w,h)
        elseif randomX > xyObject[o][i][1] and randomX < xyObject[o][i][2] and
               randomY+h > xyObject[o][i][3] and randomY+h < xyObject[o][i][4] then
            return background1:randomXY(o,w,h)
        elseif randomX+w > xyObject[o][i][1] and randomX+w < xyObject[o][i][2] and
               randomY > xyObject[o][i][3] and randomY < xyObject[o][i][4] then
            return background1:randomXY(o,w,h)
        elseif randomX+w > xyObject[o][i][1] and randomX+w < xyObject[o][i][2] and
               randomY+h > xyObject[o][i][3] and randomY+h < xyObject[o][i][4] then
            return background1:randomXY(o,w,h)
        end
        i = i+1
    end
    return randomX,randomY
end
--xy随机数相同重新生成一个
function background1:randomXY(o,w,h)
    while true do
        local randomX = math.random()*sceneW + 1
        local randomY = math.random()*sceneH + 1
        local randomState = false
        local l = 1
        --print("------------>>>>>>>>")
        while l do
            if type(xyObject[o][l]) == "nil" then break end
            if randomX > xyObject[o][l][1] and randomX < xyObject[o][l][2] and
                randomY > xyObject[o][l][3] and randomY < xyObject[o][l][4] then
                randomState = true
                --print("111111111111")
                break
            elseif randomX > xyObject[o][l][1] and randomX < xyObject[o][l][2] and
                randomY+h > xyObject[o][l][3] and randomY+h < xyObject[o][l][4] then
                    randomState = true
                --print("222222222222")
                break
            elseif randomX+w > xyObject[o][l][1] and randomX+w < xyObject[o][l][2] and
                randomY > xyObject[o][l][3] and randomY < xyObject[o][l][4] then
                    randomState = true
                --print("3333333333333333333")
                break
            elseif randomX+w > xyObject[o][l][1] and randomX+w < xyObject[o][l][2] and
                randomY+h > xyObject[o][l][3] and randomY+h < xyObject[o][l][4] then
                    randomState = true
                --print("4444444444")
                break
            end
            l = l+1
        end
        --print(randomState)
        if randomState == false then
            return randomX,randomY
        end
    end

end

return background1
