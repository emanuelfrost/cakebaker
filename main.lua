local pos = require "base.positioning"
local msg = require "base.messaging"
local tra = require "base.transitioning"
local touch = require "base.touching"
local ox, oy, dw, dh = pos.getDisplay()
local bg = display.newRect(pos.getDisplay())
bg:setFillColor(120/255,144/255,1)
pos.bake(bg, {grid={4,4}})


local r = display.newRect(0, 0, 200, 200)
r:setFillColor(1,0,0)
pos.bake(r, {parent = bg})
r:grid(1,1)
touch.bake(r)
msg.bake(r)
tra.bake(r)
r:cc()
local so = tra.getScale(r, 100, 100, 10)
local si = tra.getScale(r, 0, 0, 1000, 0, easing.outElastic)
r:buttonize({
onClick=function() 
    r:animate({so}):run() 
end,
onEnd=function() 
    r:animate({si}):run() 
end})

    

