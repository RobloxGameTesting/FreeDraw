local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "internal")
local getRemoteOrThrow = import.getRemoteOrThrow
local IS_SERVER = import.IS_SERVER
local waitForRemote = import.waitForRemote

local object = setmetatable({}, {
	__tostring = function(): string
		return "ClientFunction"
	end
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p)
	self.instance = getRemoteOrThrow("RemoteFunction", p)

	assert(not IS_SERVER, "Cannot create a Net.ClientFunction on the Server!")
end
function object.Wait(_, p)
	return RuntimeLib.Promise.defer(RuntimeLib.async(function(callback)
		RuntimeLib.await(waitForRemote("RemoteFunction", p, 60))
		callback(object.new(p))
	end))
end

function object.CallServer(p, ...)
	return p.instance:InvokeServer(unpack({ ... }))
end

object.CallServerAsync = RuntimeLib.async(function(p, ...)
	local v = { ... }
	return RuntimeLib.Promise.defer(function(callback)
		callback((p.instance:InvokeServer(unpack(v))))
	end)
end)

return { default = object }