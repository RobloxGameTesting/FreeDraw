local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local clientDefinitionBuilder = RuntimeLib.import(script, script.Parent, "ClientDefinitionBuilder").ClientDefinitionBuilder
local serverDefinitionBuilder = RuntimeLib.import(script, script.Parent, "ServerDefinitionBuilder").ServerDefinitionBuilder
local RunService = game:GetService("RunService")

local object = setmetatable({}, { __mode = "k" })

local object2 = setmetatable({}, {
	__tostring = function(): string
		return "NamespaceBuilder"
	end
})

object2.__index = object2
function object2.new(...)
	local object3 = setmetatable({}, object2)
	return object3:constructor(...) or object3
end

function object2:constructor(p)
	object[self] = p
end
function object2._buildServerDefinition(p, p2, p3)
	assert((RunService:IsServer()))

	return serverDefinitionBuilder.new(object[p], p2, p3)
end

function object2._buildClientDefinition(p, p2)
	assert((RunService:IsClient()))

	return clientDefinitionBuilder.new(object[p], p2)
end

return { NamespaceBuilder = object2 }