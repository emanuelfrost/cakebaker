local Positioning = {}

local setPos = function(obj, x, y, opt)    
    obj.x = x 
    obj.y = y  
end

local anchor = function(obj, x, y, opt)    
    obj.anchorX = x 
    obj.anchorY = y 
end

--Positioning

Positioning.tl = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x-opt.parent.anchorX*opt.parent.contentWidth  
        obj.y = opt.parent.y-opt.parent.anchorY*opt.parent.contentHeight          
    else
        setPos(obj, 0, 0, opt)        
    end
    
    return obj
end

Positioning.tc = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x+opt.parent.contentWidth/2-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y-opt.parent.anchorY*opt.parent.contentHeight          
    else
        setPos(obj, display.contentCenterX, 0, opt) 
    end
    
    return obj
end

Positioning.tr = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x+opt.parent.contentWidth-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y-opt.parent.anchorY*opt.parent.contentHeight          
    else
        setPos(obj, display.contentWidth, 0, opt) 
    end
    
    return obj
end


Positioning.cl = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y+opt.parent.contentHeight/2-opt.parent.anchorY*opt.parent.contentHeight
    else
        setPos(obj, 0, display.contentCenterY, opt)      
    end
    
    return obj
end

Positioning.cc = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x+opt.parent.contentWidth/2-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y+opt.parent.contentHeight/2-opt.parent.anchorY*opt.parent.contentHeight
    else
        setPos(obj, display.contentCenterX, display.contentCenterY, opt)   
    end
    
    return obj
end

Positioning.cr = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x+opt.parent.contentWidth-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y+opt.parent.contentHeight/2-opt.parent.anchorY*opt.parent.contentHeight
    else
        setPos(obj, display.contentWidth, display.contentCenterY, opt)           
    end
    
    return obj
end


Positioning.bl = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y+opt.parent.contentHeight-opt.parent.anchorY*opt.parent.contentHeight
    else
        setPos(obj, 0, display.contentHeight, opt) 
    end
    
    return obj
end

Positioning.bc = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x+opt.parent.contentWidth/2-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y+opt.parent.contentHeight-opt.parent.anchorY*opt.parent.contentHeight
    else
        setPos(obj, display.contentCenterX, display.contentHeight, opt)        
    end
    
    return obj
end

Positioning.br = function( obj, opt )
    if opt and opt.parent then
        obj.x = opt.parent.x+opt.parent.contentWidth-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y+opt.parent.contentHeight-opt.parent.anchorY*opt.parent.contentHeight
    else
        setPos(obj, display.contentWidth, display.contentHeight, opt)           
    end
    
    return obj
end


Positioning.pos = function ( obj, xp, yp, opt )
    if opt and opt.parent then 
        obj.x = opt.parent.x+opt.parent.contentWidth*xp-opt.parent.anchorX*opt.parent.contentWidth
        obj.y = opt.parent.y+opt.parent.contentHeight*yp-opt.parent.anchorY*opt.parent.contentHeight
    else
        setPos(obj, display.contentWidth*xp, display.contentHeight*yp, opt)           
    end
    
    return obj
end

--Anchoring

Positioning.atl = function( obj, opt )
    anchor(obj, 0, 0, opt)
    return obj
end

Positioning.atc = function( obj, opt )
    anchor(obj, .5, 0, opt)
    return obj
end

Positioning.atr = function( obj, opt )
    anchor(obj, 1, 0, opt)
    return obj
end


Positioning.acl = function( obj, opt )
    anchor(obj, 0, .5, opt)
    return obj
end

Positioning.acc = function( obj, opt )
    anchor(obj, .5, .5, opt)
    return obj
end

Positioning.acr = function( obj, opt )
    anchor(obj, 1, .5, opt)
    return obj
end


Positioning.abl = function( obj, opt )
    anchor(obj, 0, 1, opt)
    return obj
end

Positioning.abc = function( obj, opt )
    anchor(obj, .5, 1, opt)
    return obj
end

Positioning.abr = function( obj, opt )
    anchor(obj, 1, 1, opt)
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
    
    function obj:tl(opt) return Positioning.tl(self, wrapPosOpt(opt)) end    
    function obj:tc(opt) return Positioning.tc(self, wrapPosOpt(opt)) end    
    function obj:tr(opt) return Positioning.tr(self, wrapPosOpt(opt)) end
    
    function obj:cl(opt) return Positioning.cl(self, wrapPosOpt(opt)) end    
    function obj:cc(opt) return Positioning.cc(self, wrapPosOpt(opt)) end    
    function obj:cr(opt) return Positioning.cr(self, wrapPosOpt(opt)) end
    
    function obj:bl(opt) return Positioning.bl(self, wrapPosOpt(opt)) end    
    function obj:bc(opt) return Positioning.bc(self, wrapPosOpt(opt)) end    
    function obj:br(opt) return Positioning.br(self, wrapPosOpt(opt)) end
    
    function obj:pos(xp, yp, opt) return Positioning.pos(self, xp, yp, wrapPosOpt(opt)) end
    
    function obj:atl(opt) return Positioning.atl(self, opt) end    
    function obj:atc(opt) return Positioning.atc(self, opt) end    
    function obj:atr(opt) return Positioning.atr(self, opt) end
    
    function obj:acl(opt) return Positioning.acl(self, opt) end    
    function obj:acc(opt) return Positioning.acc(self, opt) end    
    function obj:acr(opt) return Positioning.acr(self, opt) end
    
    function obj:abl(opt) return Positioning.abl(self, opt) end    
    function obj:abc(opt) return Positioning.abc(self, opt) end    
    function obj:abr(opt) return Positioning.abr(self, opt) end
    
    return obj
end

return Positioning

