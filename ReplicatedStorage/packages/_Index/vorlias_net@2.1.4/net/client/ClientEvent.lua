local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "internal")
local getRemoteOrThrow = import.getRemoteOrThrow
local IS_SERVER = import.IS_SERVER
local waitForRemote = import.waitForRemote

local object = setmetatable({}, {
	__tostring = function(): string
		return "ClientEvent"
	end
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p)
	self.instance = getRemoteOrThrow("RemoteEvent", p)

	assert(not IS_SERVER, "Cannot fetch NetClientEvent on the server!")
end
function object.GetInstance(p)
	return p.instance
end

function object.Wait(_, p)
	return RuntimeLib.Promise.defer(RuntimeLib.async(function(callback)
		RuntimeLib.await(waitForRemote("RemoteEvent", p, 60))
		callback(object.new(p))
	end))
end

function object.SendToServer(p, ...)
	p.instance:FireServer(unpack({ ... }))
end
function object:Connect(onOnClientEvent)
	return self.instance.OnClientEvent:Connect(onOnClientEvent)
end

return { default = object }