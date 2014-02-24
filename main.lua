local pos = require "base.positioning"

local big = display.newRect(0, 0, 600, 600)
big:setFillColor(120/255,144/255,1)
pos.bake(big, {grid={3,3}})
big:pos(.5,.25):acc()

local r = display.newRect(0, 0, 200, 200)
r:setFillColor(1,0,0)
pos.bake(r, {parent = big})
--r:pos(0,0):acc():pushdown(.5):pushright(.5)

r:pos(.5,.25):acl()


local r2 = display.newRect(0, 0, 200, 200)
r2:setFillColor(1,1,0)
pos.bake(r2)
--r:pos(0,0):acc():pushdown(.5):pushright(.5)

r2:toRightOf(r):pushright(.5)
