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

local getPos = function(obj, xMod, yMod)
    local x = obj.x-obj.anchorX*obj.contentWidth+xMod  
    local y = obj.y-obj.anchorY*obj.contentHeight+yMod 
    
    return x, y
end

--Positioning

Positioning.tl = function( opt )
    local x,y
    if hasParent(opt) then        
        x,y = getPos(opt.parent, 0, 0)  
    else
        x,y = 0, 0
    end
    
    return x,y
end

Positioning.tc = function( opt )
    local x,y
    if hasParent(opt) then        
        x,y = getPos(opt.parent, opt.parent.contentWidth/2,0)
    else
        x,y = display.contentCenterX, 0
    end
    
    return x,y
end

Positioning.tr = function( opt )
    local x,y
    if hasParent(opt) then        
        x,y = getPos(opt.parent, opt.parent.contentWidth,0)
    else
        x,y = display.contentWidth, 0
    end
    
    return x,y
end


Positioning.cl = function( opt )
    local x,y 
    if hasParent(opt) then        
        x,y = getPos(opt.parent, 0,opt.parent.contentHeight/2)
    else
        x,y = 0, display.contentCenterY
    end
    
    return x,y
end

Positioning.cc = function( opt )
    local x,y
    if hasParent(opt) then
        x,y = getPos(opt.parent, opt.parent.contentWidth/2,opt.parent.contentHeight/2)
    else
        x,y = display.contentCenterX, display.contentCenterY
    end
    
    return x,y
end

Positioning.cr = function( opt )
    local x,y
    if hasParent(opt) then
        x,y = getPos(opt.parent, opt.parent.contentWidth,opt.parent.contentHeight/2)
    else
        x,y = display.contentWidth, display.contentCenterY           
    end
    
    return x,y
end


Positioning.bl = function( opt )
    local x,y
    if hasParent(opt) then        
        x,y = getPos(opt.parent, 0,opt.parent.contentHeight)
    else
        x,y = 0, display.contentHeight
    end
    
    return x,y
end

Positioning.bc = function( opt )
    local x,y
    if hasParent(opt) then        
        x,y = getPos(opt.parent, opt.parent.contentWidth/2,opt.parent.contentHeight)
    else
        x,y = display.contentCenterX, display.contentHeight        
    end
    
    return x,y
end

Positioning.br = function( opt )
    local x,y
    if hasParent(opt) then        
        x,y = getPos(opt.parent, opt.parent.contentWidth,opt.parent.contentHeight)
    else
        x,y = display.contentWidth, display.contentHeight
    end
    
    return x,y
end


Positioning.pos = function ( xMod, yMod, opt )
    local x,y
    if hasParent(opt) then 
        x,y = getPos(opt.parent, opt.parent.contentWidth*xMod,opt.parent.contentHeight*yMod)
    else
        x,y = display.contentWidth*xMod, display.contentHeight*yMod           
    end
    
    return x,y
end

--display

Positioning.getDisplay = function(excludeStatusbarContentHeight)
    local exstat = excludeStatusbarContentHeight or true
    local ox = display.contentCenterX
    local oy = display.contentCenterY    
    local dw = display.contentWidth
    local dh = display.contentHeight
    
    if exstat == true then
        oy = oy + display.topStatusBarContentHeight/2
        dh = dh - display.topStatusBarContentHeight
    end
    
    return ox, oy, dw, dh
end

--Grid

Positioning.grid = function ( xMod, yMod, opt )
    local x,y
    if parentHasGrid(opt) then         
        x,y = opt.parent:getGridPos(xMod,yMod)
    end
    
    return x,y
end

Positioning.setGrid = function ( obj, grid )
    local xGrid = obj.contentWidth/grid[1]
    local yGrid = obj.contentHeight/grid[2]
    
    function obj:getGridPos(x,y)
        return getPos(obj, x*xGrid,y*yGrid)        
    end
        
    return obj
end

--Below, above, ToLeftOf, ToRightOf

Positioning.below = function ( target )
    local ccx, ccy = Positioning.getCc(target)
    local blx, bly = Positioning.getBl(target)
    return ccx, bly
end

Positioning.above = function ( target )
    local ccx, ccy = Positioning.getCc(target)
    local tlx, tly = Positioning.getTl(target)
    return ccx, tly  
end

Positioning.toLeftOf = function ( target )
    local ccx, ccy = Positioning.getCc(target)
    local tlx, tly = Positioning.getTl(target)
    return tlx, ccy  
end

Positioning.toRightOf = function ( target )
    local ccx, ccy = Positioning.getCc(target)
    local trx, try = Positioning.getTr(target)
    return trx, ccy  
end

--Absolute positioning

Positioning.belowTopOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0        
    local tx,ty = Positioning.above(target)    
    tx = tx - ((0.5-p)*(target.contentWidth-obj.contentWidth))-((0.5-obj.anchorX)*obj.contentWidth)
    ty = ty + obj.anchorY*obj.contentHeight    
    return tx+x,ty+y
end

Positioning.aboveTopOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0
    local tx,ty = Positioning.above(target)
    tx = tx - ((0.5-p)*(target.contentWidth-obj.contentWidth))-((0.5-obj.anchorX)*obj.contentWidth)
    ty = ty - (1-obj.anchorY)*obj.contentHeight
    return tx+x,ty+y
end

Positioning.belowBottomOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0
    local tx,ty = Positioning.below(target)
    tx = tx - ((0.5-p)*(target.contentWidth-obj.contentWidth))-((0.5-obj.anchorX)*obj.contentWidth)
    ty = ty + obj.anchorY*obj.contentHeight
    return tx+x,ty+y
end

Positioning.aboveBottomOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0
    local tx,ty = Positioning.below(target)
    tx = tx - ((0.5-p)*(target.contentWidth-obj.contentWidth))-((0.5-obj.anchorX)*obj.contentWidth)
    ty = ty - (1-obj.anchorY)*obj.contentHeight
    return tx+x,ty+y
end

Positioning.beforeLeftOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0
    local tx,ty = Positioning.toLeftOf(target)
    ty = ty - ((0.5-p)*(target.contentHeight-obj.contentHeight))-((0.5-obj.anchorY)*obj.contentHeight)
    tx = tx - (1-obj.anchorX)*obj.contentWidth
    return tx+x,ty+y
end

Positioning.afterLeftOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0
    local tx,ty = Positioning.toLeftOf(target)
    ty = ty - ((0.5-p)*(target.contentHeight-obj.contentHeight))-((0.5-obj.anchorY)*obj.contentHeight)
    tx = tx + obj.anchorX*obj.contentWidth
    return tx+x,ty+y
end

Positioning.beforeRightOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0
    local tx,ty = Positioning.toRightOf(target)
    ty = ty - ((0.5-p)*(target.contentHeight-obj.contentHeight))-((0.5-obj.anchorY)*obj.contentHeight)
    tx = tx - (1-obj.anchorX)*obj.contentWidth
    return tx+x,ty+y
end

Positioning.afterRightOf = function ( obj, target, p, x, y )
    local p,x,y = p or 0, x or 0, y or 0
    local tx,ty = Positioning.toRightOf(target)
    ty = ty - ((0.5-p)*(target.contentHeight-obj.contentHeight))-((0.5-obj.anchorY)*obj.contentHeight)
    tx = tx + obj.anchorX*obj.contentWidth
    return tx+x,ty+y
end

--Getters

Positioning.getTl = function(obj)
    local x = obj.x-obj.anchorX*obj.contentWidth 
    local y = obj.y-obj.anchorY*obj.contentHeight
    
    return x, y
end

Positioning.getTr = function(obj)
    local x = obj.x+(1-obj.anchorX)*obj.contentWidth 
    local y = obj.y-obj.anchorY*obj.contentHeight
    
    return x, y
end

Positioning.getBl = function(obj)
    local x = obj.x-obj.anchorX*obj.contentWidth 
    local y = obj.y+(1-obj.anchorY)*obj.contentHeight
    
    return x, y
end

Positioning.getBr = function(obj)
    local x = obj.x+(1-obj.anchorX)*obj.contentWidth 
    local y = obj.y+(1-obj.anchorY)*obj.contentHeight
    
    return x, y
end

Positioning.getCc = function(obj)
    local x = obj.x+(.5-obj.anchorX)*obj.contentWidth 
    local y = obj.y+(.5-obj.anchorY)*obj.contentHeight
    
    return x, y
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
    return x,y
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
    
    local setPosW = function(obj, x, y)
        setPos(obj, x, y)
        return obj
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
    
    function obj:tl(opt) return setPosW(self, Positioning.tl(wrapPosOpt(opt))) end    
    function obj:tc(opt) return setPosW(self, Positioning.tc(wrapPosOpt(opt))) end    
    function obj:tr(opt) return setPosW(self, Positioning.tr(wrapPosOpt(opt))) end
    
    function obj:cl(opt) return setPosW(self, Positioning.cl(wrapPosOpt(opt))) end    
    function obj:cc(opt) return setPosW(self, Positioning.cc(wrapPosOpt(opt))) end    
    function obj:cr(opt) return setPosW(self, Positioning.cr(wrapPosOpt(opt))) end
    
    function obj:bl(opt) return setPosW(self, Positioning.bl(wrapPosOpt(opt))) end    
    function obj:bc(opt) return setPosW(self, Positioning.bc(wrapPosOpt(opt))) end    
    function obj:br(opt) return setPosW(self, Positioning.br(wrapPosOpt(opt))) end
    
    function obj:pos(x, y, opt) return setPosW(self, Positioning.pos(x, y, wrapPosOpt(opt))) end
    function obj:grid(x, y, opt) return setPosW(self, Positioning.grid(x, y, wrapPosOpt(opt))) end
    
    function obj:below(target) return setPosW(self, Positioning.below(target)) end
    function obj:above(target) return setPosW(self, Positioning.above(target)) end
    function obj:toLeftOf(target) return setPosW(self, Positioning.toLeftOf(target)) end
    function obj:toRightOf(target) return setPosW(self, Positioning.toRightOf(target)) end
        
    function obj:belowTopOf(target, p, x, y ) 
        return setPosW(self, Positioning.belowTopOf(self, target, p, x, y ))        
    end
    
    function obj:aboveTopOf(target, p, x, y) 
        return setPosW(self, Positioning.aboveTopOf(self, target, p, x, y ))  
    end
    
    function obj:belowBottomOf(target, p, x, y) 
        return setPosW(self, Positioning.belowBottomOf(self, target, p, x, y ))  
    end
    
    function obj:aboveBottomOf(target, p, x, y) 
        return setPosW(self, Positioning.aboveBottomOf(self, target, p, x, y ))  
    end
    
    function obj:beforeLeftOf(target, p, x, y) 
        return setPosW(self, Positioning.beforeLeftOf(self, target, p, x, y ))  
    end
    
    function obj:afterLeftOf(target, p, x, y) 
        return setPosW(self, Positioning.afterLeftOf(self, target, p, x, y ))  
    end
    
    function obj:beforeRightOf(target, p, x, y) 
        return setPosW(self, Positioning.beforeRightOf(self, target, p, x, y ))  
    end
    
    function obj:afterRightOf(target, p, x, y) 
        return setPosW(self, Positioning.afterRightOf(self, target, p, x, y ))  
    end
        
    function obj:getTl()
        local x,y = Positioning.getTl(self)        
        return {x=x, y=y}
    end
    
    function obj:getTr()
        local x,y = Positioning.getTr(self)        
        return {x=x, y=y}
    end
    
    function obj:getBl()
        local x,y = Positioning.getBl(self)        
        return {x=x, y=y}
    end
    
    function obj:getBr()
        local x,y = Positioning.getBr(self)        
        return {x=x, y=y}
    end
    
    function obj:getCc()
        local x,y = Positioning.getCc(self)        
        return {x=x, y=y}
    end
        
    function obj:atl() return Positioning.atl(self) end    
    function obj:atc() return Positioning.atc(self) end    
    function obj:atr() return Positioning.atr(self) end
    
    function obj:acl() return Positioning.acl(self) end    
    function obj:acc() return Positioning.acc(self) end    
    function obj:acr() return Positioning.acr(self) end
    
    function obj:abl() return Positioning.abl(self) end    
    function obj:abc() return Positioning.abc(self) end    
    function obj:abr() return Positioning.abr(self) end
        
    function obj:pushLeft(mod) return setPosW(self, Positioning.push(self, -getPushMod(mod), 0)) end    
    function obj:pushUp(mod) return setPosW(self, Positioning.push(self, 0, -getPushMod(mod))) end
    function obj:pushRight(mod) return setPosW(self, Positioning.push(self, getPushMod(mod), 0)) end    
    function obj:pushDown(mod) return setPosW(self, Positioning.push(self, 0, getPushMod(mod))) end    
        
    return obj
end

return Positioning

