local pos = require "base.positioning"

local big = display.newRect(0, 0, 600, 600)
big:setFillColor(120/255,144/255,1)
pos.bake(big)
big:pos(.5,.5):acc()

local r = display.newRect(0, 0, 200, 200)
r:setFillColor(1,0,0)
pos.bake(r, {parent = big})
r:pos(.5,.5):atc()
