local msg = require "base.messaging"
local pos = require "base.positioning"

local Touching = {}

Touching.makeDraggable = function(obj, opt)
    local options = opt or {}
    local snap = options.snap
    local grid = options.grid or {10,10}
    local dragX = options.dragX == nil and true or options.dragX 
    local dragY = options.dragY == nil and true or options.dragY
    
    local getNearestSnapPos = function(x,y)
        local xGrid = snap.contentWidth/grid[1]
        local yGrid = snap.contentHeight/grid[2]

        local pX = (x/xGrid)*grid[1]
        local pY = (y/yGrid)*grid[2]

        local pXAbs = math.floor(pX < 100 and pX < 0 and 0 or pX or 100)
        local pYAbs = math.floor(pY < 100 and pY < 0 and 0 or pY or 100)

        return pos.getPos(snap, (pXAbs/100)*xGrid, (pYAbs/100)*yGrid)                                                                                                              
    end

    
    
    function obj:touch( event )
        local x = (event.x - event.xStart) + (self.dragStartX or 0)
        local y = (event.y - event.yStart) + (self.dragStartY or 0)
            
        local setXYPos = function(xPos,yPos)
            if dragX then
                self.x = xPos
            end
            if dragY then
                self.y = yPos
            end
        end    
            
        if event.phase == "began" then
            self.dragStartX = self.x    
            self.dragStartY = self.y    
        elseif event.phase == "ended" then
--            if snap ~= nil then                 
--                setXYPos(getNearestSnapPos(x,y))
--                
--            end
        elseif event.phase == "moved" then
            
            if snap ~= nil then                 
                local tol = 10
                
                local nx,ny = getNearestSnapPos(x, y)
                if nx > x-tol or nx < x+tol then
                    setXYPos(nx, ny)
                else
                    
                    setXYPos(x,y)
                end
                
                --x,y = pos.getPos(snap, math.floor()*xGrid,math.floor(y/yGrid)*yGrid)
            else
            
            setXYPos(x,y)
            end
        end
        return true
    end
 
    obj:addEventListener( "touch", obj )
    
    return obj
end

Touching.bake = function(obj)
    function obj:draggable(opt)
        return Touching.makeDraggable(self, opt)
    end
end

return Touching

