local Messaging = {}

--Global messaging

Messaging.subscribeTo = function( obj, name, action )    
    if obj.subscriptions[name] == nil then
        obj.subscriptions[name] = action    
        Runtime:addEventListener( name, action )
    end    
    return obj
end

Messaging.publish = function( name, params )
    if not params then
        params = {}
    end
    params.name = name
    Runtime:dispatchEvent( params )    
end

Messaging.unsubscribeAll = function( obj )    
    for key,value in pairs(obj.subscriptions) do 
        Runtime:removeEventListener( key, value )
    end
    return obj
end

Messaging.unsubscribeTo = function( obj, name )    
    if obj.subscriptions[name] ~= nil then
        Runtime:removeEventListener( name, obj.subscriptions[name] )
    end    
    return obj
end

--Local messaging (events)

Messaging.removeEvents = function( obj )    
    for key,value in pairs(obj.events) do 
        obj:removeEventListener( key, value )
    end
    return obj
end

Messaging.removeEvent = function( obj, name )    
    if obj.events[name] ~= nil then
        obj:removeEventListener( name, obj.events[name] )
    end    
    return obj
end

Messaging.on = function( obj, name, action )    
    if obj.events[name] == nil then
        obj.events[name] = action    
        obj:addEventListener( name, action )
    end    
    return obj
end

Messaging.say = function( obj, name, params )
    if not params then
        params = {}
    end
    params.name = name
    obj:dispatchEvent( params )  
    return obj
end

Messaging.bake = function( obj )    
    obj.subscriptions = {}
    obj.events = {}
    
    function obj:subscribeTo(name, action) return Messaging.subscribeTo(self, name, action ) end 

    function obj:unsubscribeAll() return Messaging.unsubscribeAll( self ) end     
    
    function obj:unsubscribeTo( name ) return Messaging.unsubscribeTo( self, name ) end     
    
    function obj:on(name, action) return Messaging.on(self, name, action ) end 

    function obj:say(name, params) return Messaging.say(self, name, params ) end 

    function obj:removeEvents() return Messaging.removeEvents( self ) end     
    
    function obj:removeEvent( name ) return Messaging.removeEvent( self, name ) end     
    
    function obj:disposeMessaging() 
        Messaging.removeEvents( self ) 
        Messaging.unsubscribeAll( self ) 
    end    
    
    return obj
end

return Messaging

