local msg = require "base.messaging"

local Touching = {}

local events = {
    ClickBegan = "click-began",
    ClickCancelled = "click-cancelled",
    ClickReleased = "click-released",
}

Touching.events = events

Touching.clickable = function (obj)
    function obj:touch( event ) 
        if event.phase == "began" then     
            msg.trigger(obj, events.ClickBegan)            
            display.getCurrentStage():setFocus( self )
            self.isFocus = true      
        elseif self.isFocus then
            if event.phase == "moved" then                                
                local bounds = self.contentBounds       
                if event.x < bounds.xMin or event.y < bounds.yMin or event.x > bounds.xMax or event.y > bounds.yMax then                
                    display.getCurrentStage():setFocus( nil )
                    self.isFocus = nil
                    msg.trigger(obj, events.ClickCancelled)
                end
            elseif event.phase == "ended" or event.phase == "cancelled" then   
                display.getCurrentStage():setFocus( nil )
                self.isFocus = nil
                
                if event.phase == "ended" then
                    msg.trigger(obj, events.ClickReleased)
                else
                    msg.trigger(obj, events.ClickCancelled)
                end
            end
        end
        return true
    end
    
    obj:addEventListener( "touch", obj )
    
    return obj
end

Touching.buttonize = function (obj, opt)
    Touching.clickable(obj)
    
    opt = opt or {}
    
    local onClick = opt.onClick or function()end
    local onEnd = opt.onEnd or function()end
    
    msg.on(obj, events.ClickBegan, onClick)
    msg.on(obj, events.ClickCancelled, onEnd)
    msg.on(obj, events.ClickReleased, onEnd)
    
    return obj
end

Touching.bake = function(obj)
    function obj:clickable() return Touching.clickable(self) end
    function obj:buttonize(opt) return Touching.buttonize(self, opt) end
    return obj
end

return Touching

