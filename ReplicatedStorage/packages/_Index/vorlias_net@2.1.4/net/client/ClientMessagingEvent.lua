local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local getGlobalRemote = RuntimeLib.import(script, script.Parent.Parent, "internal").getGlobalRemote
local default = RuntimeLib.import(script, script.Parent, "ClientEvent").default

local object = setmetatable({}, {
	__tostring = function(): string
		return "ClientMessagingEvent"
	end
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p)
	self.instance = default.new(getGlobalRemote(p))
end
function object:Connect(onInstance)
	self.instance:Connect(onInstance)
end

return { default = object }