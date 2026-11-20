local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "internal")
local findOrCreateRemote = import.findOrCreateRemote
local IS_SERVER = import.IS_SERVER
local default = RuntimeLib.import(script, script.Parent, "MiddlewareFunction").default

local object = setmetatable({}, {
	__tostring = function(): string
		return "ServerFunction"
	end,
	__index = default
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p, p2)
	local v = p2 == nil and {} or p2

	default.constructor(self, v)
	self.instance = findOrCreateRemote("RemoteFunction", p, function(p3)
		p3.OnServerInvoke = object.DefaultFunctionHook
	end)
	assert(IS_SERVER, "Cannot create a Net.ServerFunction on the Client!")
end
function object.GetInstance(p)
	return p.instance
end

function object.SetCallback(object2, p)
	object2.instance.OnServerInvoke = function(p2, ...)
		local v = { ... }
		local v2 = object2:_processMiddleware(p)

		if v2 ~= nil then
			v2 = v2(p2, unpack(v))
		end

		if not RuntimeLib.Promise.is(v2) then
			return v2
		end

		warn("[rbx-net] WARNING: Promises should be used with an AsyncFunction!")
		local v3, v4 = v2:await()

		if v3 then
			return v4
		end

		error(v4)

		return v2
	end
end
function object.DefaultFunctionHook(): nil
	return nil
end

return { default = object }