local msg = require "base.messaging"
local Transitioning = {}

Transitioning.dispose = function(handler)
    if handler ~= nil then
        transition.cancel(handler)
        handler = nil
    end
end

Transitioning.chainMoveTo = function(obj, x, y, d, w)
    Transitioning.dispose(obj.transition)
    local delay = not w and 0 or w
    local time = not d and 1000 or d
    table.insert(obj.transitionChain, {time=time, delay=delay, x=x, y=y, onComplete=obj.nextTransition})
end

Transitioning.getXyTrans = function(xy, d, w)
    return {x=xy.x,y=xy.y,d=d,w=w}
end

Transitioning.bake = function( obj )    
    obj.transition = nil
    obj.transitionChain = {}    
    
    obj.nextTransition = function()
        Transitioning.dispose(obj.transition)
        if #obj.transitionChain > 0 then
            local tran = table.remove(obj.transitionChain, 1)
            obj.transition = transition.to(obj, tran)
        else
            msg.say("chaincomplete")
        end
    end
    
    function obj:moveTo(x,y,d,w) 
        Transitioning.chainMoveTo(self, x, y, d, w)                
        return self 
    end
    
    function obj:moveToChain(chain)  
        for i=1, #chain do
            Transitioning.chainMoveTo(self, chain[i].x, chain[i].y, chain[i].d, chain[i].w)  
        end                      
        return self 
    end
    
    function obj:runChain()  
        self.nextTransition()                
        return self 
    end
        
    return obj
end

return Transitioning

