local msg = require "base.messaging"
local Transitioning = {}

local events = {
    ChainComplete = "chaincomplete"
}

Transitioning.events = events

Transitioning.dispose = function(handler)
    if handler ~= nil then
        transition.cancel(handler)
        handler = nil
    end
end

Transitioning.addTransition = function(obj, params)
    Transitioning.dispose(obj.transition)
    
    params.onComplete = function()
        if params.completed then
            params.completed()
        end
        obj.nextTransition()
    end
        
    table.insert(obj.transitions, params)
end

Transitioning.getXy = function(x, y, t, d, ease)
    local e = ease or easing.linear
    return {x=x,y=y,time=t,delay=d,transition=e}
end

Transitioning.getAlpha = function(a, t, d, ease)
    local e = ease or easing.linear
    return {alpha=a,time=t,delay=d,transition=e}
end

Transitioning.getScale = function(obj, scaleX, scaleY, t, d, ease)
    ease = ease or easing.linear
    d = d or 0
    
    local xScaleVar = (obj.contentWidth+scaleX)/obj.contentWidth
    local yScaleVar = (obj.contentHeight+scaleY)/obj.contentHeight
    
    return {xScale=xScaleVar,yScale=yScaleVar,time=t,delay=d,transition=ease}    
end

Transitioning.merge = function(t1,t2)
    local m = {}
    for key,value in pairs(t1) do 
        m[key] = value
    end
    for key,value in pairs(t2) do 
        m[key] = value
    end
    return m
end

Transitioning.bake = function( obj )    
    obj.transition = nil
    obj.transitions = {}    
    
    obj.nextTransition = function()
        Transitioning.dispose(obj.transition)
        if #obj.transitions > 0 then
            local tran = table.remove(obj.transitions, 1)
            obj.transition = transition.to(obj, tran)
        else
            msg.trigger(obj, events.ChainComplete)
        end
    end
    
    function obj:animate(transitions)  
        for i=1, #transitions do
            Transitioning.addTransition(self, transitions[i])  
        end                      
        return self 
    end
    
    function obj:run()  
        self.nextTransition()                
        return self 
    end
        
    return obj
end

return Transitioning

