local Positioning = {}

local hasGrid = function(opt)
    if opt and opt.grid then
        return true
    end
    return false
end

local hasParent = function(opt)
    if opt and opt.parent then
        return true
    end
    return false
end

local parentHasGrid = function(opt)
    if hasParent(opt) and opt.parent.getGridPos ~= nil then        
        return true
    end
    return false
end

local anchor = function(obj, x, y)    
    obj.anchorX = x 
    obj.anchorY = y 
end

local setPos = function(obj, x, y)    
    obj.x = x 
    obj.y = y  
end

local getParentPos = function(parent, xMod, yMod)
    local x = parent.x-parent.anchorX*parent.contentWidth+xMod  
    local y = parent.y-parent.anchorY*parent.contentHeight+yMod 
    
    return x, y
end

--Positioning

Positioning.tl = function( obj, opt )
    if hasParent(opt) then        
        setPos(obj, getParentPos(opt.parent, 0, 0))
    else
        setPos(obj, 0, 0)        
    end
    
    return obj
end

Positioning.tc = function( obj, opt )
    if hasParent(opt) then        
        setPos(obj, getParentPos(opt.parent, opt.parent.contentWidth/2,0))
    else
        setPos(obj, display.contentCenterX, 0) 
    end
    
    return obj
end

Positioning.tr = function( obj, opt )
    if hasParent(opt) then        
        setPos(obj, getParentPos(opt.parent, opt.parent.contentWidth,0))
    else
        setPos(obj, display.contentWidth, 0) 
    end
    
    return obj
end


Positioning.cl = function( obj, opt )
    if hasParent(opt) then        
        setPos(obj, getParentPos(opt.parent, 0,opt.parent.contentHeight/2))
    else
        setPos(obj, 0, display.contentCenterY)      
    end
    
    return obj
end

Positioning.cc = function( obj, opt )
    if hasParent(opt) then
        setPos(obj,getParentPos(opt.parent, opt.parent.contentWidth/2,opt.parent.contentHeight/2))
    else
        setPos(obj, display.contentCenterX, display.contentCenterY)   
    end
    
    return obj
end

Positioning.cr = function( obj, opt )
    if hasParent(opt) then
        setPos(obj, getParentPos(opt.parent, opt.parent.contentWidth,opt.parent.contentHeight/2))
    else
        setPos(obj, display.contentWidth, display.contentCenterY)           
    end
    
    return obj
end


Positioning.bl = function( obj, opt )
    if hasParent(opt) then        
        setPos(obj, getParentPos(opt.parent, 0,opt.parent.contentHeight))
    else
        setPos(obj, 0, display.contentHeight) 
    end
    
    return obj
end

Positioning.bc = function( obj, opt )
    if hasParent(opt) then        
        setPos(obj, getParentPos(opt.parent, opt.parent.contentWidth/2,opt.parent.contentHeight))
    else
        setPos(obj, display.contentCenterX, display.contentHeight)        
    end
    
    return obj
end

Positioning.br = function( obj, opt )
    if hasParent(opt) then        
        setPos(obj, getParentPos(opt.parent, opt.parent.contentWidth,opt.parent.contentHeight))
    else
        setPos(obj, display.contentWidth, display.contentHeight)           
    end
    
    return obj
end


Positioning.pos = function ( obj, x, y, opt )
    if hasParent(opt) then 
        setPos(obj, getParentPos(opt.parent, opt.parent.contentWidth*x,opt.parent.contentHeight*y))        
    else
        setPos(obj, display.contentWidth*x, display.contentHeight*y)           
    end
    
    return obj
end

--Grid

Positioning.grid = function ( obj, x, y, opt )
    if parentHasGrid(opt) then         
        setPos(obj, opt.parent:getGridPos(x,y))
    end
    
    return obj
end

Positioning.setGrid = function ( obj, grid )
    local xGrid = obj.contentWidth/grid[1]
    local yGrid = obj.contentHeight/grid[2]
    
    function obj:getGridPos(x,y)
        return getParentPos(obj, x*xGrid,y*yGrid)        
    end
        
    return obj
end

--Below, above, ToLeftOf, ToRightOf

Positioning.below = function ( obj, target, opt )
    setPos(obj, target.x, target.y+target.contentHeight)    
    return obj
end

Positioning.above = function ( obj, target, opt )
    setPos(obj, target.x, target.y-target.contentHeight)    
    return obj
end

Positioning.toLeftOf = function ( obj, target, opt )
    setPos(obj, target.x-target.contentWidth, target.y)    
    return obj
end

Positioning.toRightOf = function ( obj, target, opt )
    setPos(obj, target.x+target.contentWidth, target.y)    
    return obj
end

--Anchoring

Positioning.atl = function( obj )
    anchor(obj, 0, 0)
    return obj
end

Positioning.atc = function( obj )
    anchor(obj, .5, 0)
    return obj
end

Positioning.atr = function( obj )
    anchor(obj, 1, 0)
    return obj
end


Positioning.acl = function( obj )
    anchor(obj, 0, .5)
    return obj
end

Positioning.acc = function( obj )
    anchor(obj, .5, .5)
    return obj
end

Positioning.acr = function( obj )
    anchor(obj, 1, .5)
    return obj
end


Positioning.abl = function( obj )
    anchor(obj, 0, 1)
    return obj
end

Positioning.abc = function( obj )
    anchor(obj, .5, 1)
    return obj
end

Positioning.abr = function( obj )
    anchor(obj, 1, 1)
    return obj
end

Positioning.push = function(obj, xMod, yMod)
    local x = obj.x+(obj.contentWidth*xMod)
    local y = obj.y+(obj.contentHeight*yMod)
    setPos(obj, x, y)
    return obj
end

--Bake

Positioning.bake = function( obj, bakeOpt )    
    local wrapPosOpt = function(opt)
        if opt == nil then
            opt = {}
        end
        
        if bakeOpt and bakeOpt.parent then
            opt.parent = bakeOpt.parent
        end        
        
        return opt
    end
    
    local getPushMod = function(mod)
        if mod == nil then
            return 1
        end
        
        return mod
    end
    
    if hasGrid(bakeOpt) then
        Positioning.setGrid(obj, bakeOpt.grid)
    end
    
    function obj:tl(opt) return Positioning.tl(self, wrapPosOpt(opt)) end    
    function obj:tc(opt) return Positioning.tc(self, wrapPosOpt(opt)) end    
    function obj:tr(opt) return Positioning.tr(self, wrapPosOpt(opt)) end
    
    function obj:cl(opt) return Positioning.cl(self, wrapPosOpt(opt)) end    
    function obj:cc(opt) return Positioning.cc(self, wrapPosOpt(opt)) end    
    function obj:cr(opt) return Positioning.cr(self, wrapPosOpt(opt)) end
    
    function obj:bl(opt) return Positioning.bl(self, wrapPosOpt(opt)) end    
    function obj:bc(opt) return Positioning.bc(self, wrapPosOpt(opt)) end    
    function obj:br(opt) return Positioning.br(self, wrapPosOpt(opt)) end
    
    function obj:pos(x, y, opt) return Positioning.pos(self, x, y, wrapPosOpt(opt)) end
    function obj:grid(x, y, opt) return Positioning.grid(self, x, y, wrapPosOpt(opt)) end
    
    function obj:below(target, opt) return Positioning.below(self, target, wrapPosOpt(opt)) end
    function obj:above(target, opt) return Positioning.above(self, target, wrapPosOpt(opt)) end
    function obj:toLeftOf(target, opt) return Positioning.toLeftOf(self, target, wrapPosOpt(opt)) end
    function obj:toRightOf(target, opt) return Positioning.toRightOf(self, target, wrapPosOpt(opt)) end
        
    function obj:atl() return Positioning.atl(self) end    
    function obj:atc() return Positioning.atc(self) end    
    function obj:atr() return Positioning.atr(self) end
    
    function obj:acl() return Positioning.acl(self) end    
    function obj:acc() return Positioning.acc(self) end    
    function obj:acr() return Positioning.acr(self) end
    
    function obj:abl() return Positioning.abl(self) end    
    function obj:abc() return Positioning.abc(self) end    
    function obj:abr() return Positioning.abr(self) end
        
    function obj:pushleft(mod) return Positioning.push(self, -getPushMod(mod), 0) end    
    function obj:pushup(mod) return Positioning.push(self, 0, -getPushMod(mod)) end
    function obj:pushright(mod) return Positioning.push(self, getPushMod(mod), 0) end    
    function obj:pushdown(mod) return Positioning.push(self, 0, getPushMod(mod)) end    
        
    return obj
end

return Positioning

