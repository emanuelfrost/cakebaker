local pos = require "base.positioning"
local msg = require "base.messaging"
local tra = require "base.transitioning"
--
--local big = display.newRect(0, 0, 600, 600)
--big:setFillColor(120/255,144/255,1)
--pos.bake(big, {grid={3,3}})
--big:pos(.5,.25):acr()
--
--local r = display.newRect(0, 0, 200, 200)
--r:setFillColor(1,0,0)
--pos.bake(r, {parent = big})
--r:pos(.5,.25):acc()
--
--
--local r2 = display.newRect(0, 0, 100, 40)
--r2:setFillColor(1,1,0)
--pos.bake(r2):acc()
----r:pos(0,0):acc():pushdown(.5):pushright(.5)
--
--r2:afterRightOf(r, .5, 20, 0)
--
--tra.bake(r2)
--msg.bake(r2)
--
--local chain = {
--    tra.getXyTrans(big:getTl(),1000), 
--    tra.getXyTrans(big:getTr(),1000),
--    tra.getXyTrans(big:getBr(),1000),
--    tra.getXyTrans(big:getBl(),1000),
--    tra.getXyTrans(big:getCc(),1000),   
--}
--r2:animate(chain)
--r2:run()
--
--r2:on("chaincomplete", function()
--    r2:animate(chain)
--    r2:run()
--end)

local bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
bg:setFillColor(1/255,42/255,36/255)

local circle = display.newCircle( display.contentCenterX, display.contentCenterY, 8 )
circle:setFillColor( .5, 1, 0 )

local shitPointX, shitPointY = display.contentCenterX, display.contentCenterY

local function moveCircle( event )
    shitPointX, shitPointY = event.x, event.y
    circle.x = event.x
    circle.y = event.y
end

Runtime:addEventListener( "touch", moveCircle )

math.randomseed( os.time() )
local objects = {}

local rndScreen = function ()
    local x = math.random(0, display.contentWidth)
    local y = math.random(0, display.contentHeight)
    return {x=x,y=y}
end

local createObj = function(id)
    local rnd = rndScreen()    
    local o = display.newRect(rnd.x, rnd.y, 4, 4)
    o:setFillColor(32/255,144/255,1)
    tra.bake(o)
    msg.bake(o) 
    pos.bake(o) 
    o.id = id
    return o
end

local attachTran = function()
    local createTo = function(xy)  
        local t = math.random(500, 800)
        return tra.getXy(xy, t)
    end
    
    local startTran = function(o)        
        local rndType = math.random(1,10)
        
        if rndType == 1 then
            local t = createTo(rndScreen())            
            o:animate({t})
            o:run()
            return
        elseif rndType > 1 and rndType < 4 then
            local t = createTo({x=shitPointX, y=shitPointY})            
            o:animate({t})
            o:run()
            return
        end
        
        local rnd = math.random(1, #objects)
        while rnd == o.id do
            rnd = math.random(1, #objects)
        end    
        local t = createTo(objects[rnd]:getCc())            
        o:animate({t})
        o:run()
    end
        
    for i = 1, #objects do
        objects[i]:on(tra.messages.ChainComplete, function()        
            startTran(objects[i])
        end)
        
        startTran(objects[i])
    end
end

local count = 50
for i = 1, count do       
    table.insert(objects, createObj(i))
end

attachTran()
    

