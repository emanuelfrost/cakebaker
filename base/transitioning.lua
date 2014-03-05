local msg = require "base.messaging"
local Transitioning = {}

local messages = {
    ChainComplete = "chaincomplete"
}

Transitioning.messages = messages

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

Transitioning.getXy = function(xy, t, d, ease)
    local e = ease or easing.linear
    return {x=xy.x,y=xy.y,time=t,delay=d,transition=e}
end

Transitioning.getAlpha = function(a, t, d, ease)
    local e = ease or easing.linear
    return {alpha=a,time=t,delay=d,transition=e}
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
            msg.trigger(obj, messages.ChainComplete)
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

