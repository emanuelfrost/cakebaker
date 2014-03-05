local pos = require "base.positioning"
local msg = require "base.messaging"
local tra = require "base.transitioning"
local tou = require "base.touching"

local bg = display.newRect(pos.getDisplay())
bg:setFillColor(120/255,144/255,1)
pos.bake(bg, {grid={4,4}})


local r = display.newRect(0, 0, 200, 200)
r:setFillColor(1,0,0)
pos.bake(r, {parent = bg})
r:grid(1,1)
tou.bake(r)
r:draggable({snap=bg})

    

