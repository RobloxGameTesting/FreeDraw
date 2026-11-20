local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local default = RuntimeLib.import(script, script.Parent.Parent, "client", "ClientAsyncFunction").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "client", "ClientEvent").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "client", "ClientFunction").default

local object = setmetatable({}, { __mode = "k" })

local object2 = setmetatable({}, {
	__tostring = function(): string
		return "ClientDefinitionBuilder"
	end
})

object2.__index = object2
function object2.new(...)
	local object3 = setmetatable({}, object2)
	return object3:constructor(...) or object3
end

function object2:constructor(p, p2)
	self.namespace = p2 == nil and "" or p2

	object[self] = p
end
function object2:toString(): string
	return "[ClientDefinitionBuilder]"
end

function object2:Get(p)
	local v = object[self][p]

	if self.namespace ~= "" then
		local v2 = ":"
		local v3 = v2 == nil and ", " or v2

		p = table.concat({ self.namespace, p }, v3)
	end

	assert(v and v.Type, "'" .. p .. "' is not defined in this definition.")

	if v.Type == "Function" then
		return default3.new(p)
	end

	if v.Type == "AsyncFunction" then
		return default.new(p)
	end

	if v.Type == "Event" then
		return default2.new(p)
	end

	error("Invalid Type")
end
function object2.GetNamespace(p, p2)
	local v = object[p][p2]
	assert(v.Type == "Namespace")
	local definitions = v.Definitions

	if p.namespace ~= "" then
		local v2 = ":"
		local v3 = v2 == nil and ", " or v2

		p2 = table.concat({ p.namespace, p2 }, v3)
	end

	return definitions:_buildClientDefinition(p2)
end

object2.WaitFor = RuntimeLib.async(function(p, p2)
	local v = object[p][p2]

	if p.namespace ~= "" then
		local v2 = ":"
		local v3 = v2 == nil and ", " or v2

		p2 = table.concat({ p.namespace, p2 }, v3)
	end

	assert(v and v.Type, "'" .. p2 .. "' is not defined in this definition.")

	if v.Type == "Function" then
		return default3:Wait(p2)
	end

	if v.Type == "Event" then
		return default2:Wait(p2)
	end

	if v.Type == "AsyncFunction" then
		return default:Wait(p2)
	end

	error("Invalid Type")
end)
function object2:OnEvent(p, p2)
	self:Get(p):Connect(p2)
end
function object2:OnFunction(p, p2)
	self:Get(p):SetCallback(p2)
end
function object2:__tostring()
	return self:toString()
end

return { ClientDefinitionBuilder = object2 }