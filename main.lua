local pos = require "base.positioning"
local msg = require "base.messaging"
local tra = require "base.transitioning"

local big = display.newRect(0, 0, 600, 600)
big:setFillColor(120/255,144/255,1)
pos.bake(big, {grid={3,3}})
big:pos(.5,.25):acr()

local r = display.newRect(0, 0, 200, 200)
r:setFillColor(1,0,0)
pos.bake(r, {parent = big})
r:pos(.5,.25):acc()


local r2 = display.newRect(0, 0, 100, 100)
r2:setFillColor(1,1,0)
pos.bake(r2)
--r:pos(0,0):acc():pushdown(.5):pushright(.5)

r2:toRightOf(big)

tra.bake(r2)
msg.bake(r2)

local chain = {
    tra.getXyTrans(big:getTl(),100), 
    tra.getXyTrans(big:getTr(),100),
    tra.getXyTrans(big:getBr(),100),
    tra.getXyTrans(big:getBl(),100),
    tra.getXyTrans(big:getCc(),100),   
}
r2:moveToChain(chain)
r2:runChain()

r2:listen("chaincomplete", function()
    r2:moveToChain(chain)
    r2:runChain()
end)

