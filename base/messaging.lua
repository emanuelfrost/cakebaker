local Messaging = {}

Messaging.listen = function( obj, name, listener )    
    if obj.listeners[name] == nil then
        obj.listeners[name] = listener    
        Runtime:addEventListener( name, listener )
    end    
end

Messaging.say = function( name, params )
    if not params then
        params = {}
    end
    params.name = name
    Runtime:dispatchEvent( params )    
end

Messaging.removeListeners = function( obj )    
    for key,value in pairs(obj.listeners) do 
        Runtime:removeEventListener( key, value )
    end
end

Messaging.removeListener = function( obj, name )    
    if obj.listeners[name] ~= nil then
        Runtime:removeEventListener( name, obj.listeners[name] )
    end    
end

Messaging.bake = function( obj )    
    obj.listeners = {}
    
    function obj:listen(name, listener) return Messaging.listen(self, name, listener ) end 

    function obj:removeListeners() return Messaging.removeListeners( self ) end     
    
    function obj:removeListener( name ) return Messaging.removeListener( self, name ) end     
    
    return obj
end

return Messaging

