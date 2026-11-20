local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local default = RuntimeLib.import(script, script.Parent.Parent, "server", "ServerAsyncFunction").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "server", "ServerEvent").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "server", "ServerFunction").default
local CollectionService = game:GetService("CollectionService")

local object = setmetatable({}, { __mode = "k" })

local v = {}
local v2 = {}
local v3 = {}

local object2 = setmetatable({}, {
	__tostring = function(): string
		return "ServerDefinitionBuilder"
	end
})

object2.__index = object2
function object2.new(...)
	local object3 = setmetatable({}, object2)
	return object3:constructor(...) or object3
end

function object2:constructor(p, globalMiddleware, p2)
	local namespace = p2 == nil and "" or p2

	self.globalMiddleware = globalMiddleware
	self.namespace = namespace

	object[self] = p
end
function object2:toString(): string
	return "[ServerDefinitionBuilder]"
end

function object2:OnEvent(p, p2)
	self:Create(p):Connect(p2)
end
function object2.GetNamespace(p, p2)
	local v4 = object[p][p2]
	assert(v4.Type == "Namespace")
	local definitions = v4.Definitions
	local globalMiddleware = p.globalMiddleware

	if p.namespace ~= "" then
		local v5 = ":"
		local v6 = v5 == nil and ", " or v5

		p2 = table.concat({ p.namespace, p2 }, v6)
	end

	return definitions:_buildServerDefinition(globalMiddleware, p2)
end

function object2:Create(p)
	local v4 = object[self][p]

	if self.namespace ~= "" then
		local v5 = ":"
		local v6 = v5 == nil and ", " or v5

		p = table.concat({ self.namespace, p }, v6)
	end

	assert(v4 and v4.Type, "'" .. p .. "' is not defined in this definition.")

	local function fn(p2) -- 1 equivalent call inferred from this helper
		return v5:_use(p2)
	end

	local function fn2(p2) -- 1 equivalent call inferred from this helper
		return v5:_use(p2)
	end

	local function fn3(p2) -- 1 equivalent call inferred from this helper
		return v5:_use(p2)
	end

	if v4.Type == "Function" then
		if v3[p] ~= nil then
			return v3[p]
		end

		local v5

		if v4.ServerMiddleware then
			v5 = default3.new(p, v4.ServerMiddleware)
		else
			v5 = default3.new(p)
		end

		CollectionService:AddTag(v5:GetInstance(), "NetDefinitionManaged")

		v3[p] = v5

		local globalMiddleware = self.globalMiddleware

		if globalMiddleware ~= nil then
			for i, v6 in ipairs(globalMiddleware) do
				local _ = i - 1
				fn(v6) -- inferred equivalent call
			end
		end

		return v5
	elseif v4.Type == "AsyncFunction" then
		if v2[p] ~= nil then
			return v2[p]
		end

		local v5

		if v4.ServerMiddleware then
			v5 = default.new(p, v4.ServerMiddleware)
		else
			v5 = default.new(p)
		end

		CollectionService:AddTag(v5:GetInstance(), "NetDefinitionManaged")

		v2[p] = v5

		local globalMiddleware = self.globalMiddleware

		if globalMiddleware ~= nil then
			for i, v6 in ipairs(globalMiddleware) do
				local _ = i - 1
				fn2(v6) -- inferred equivalent call
			end
		end

		return v5
	else
		if v4.Type ~= "Event" then
			error("Invalid Type")
			return
		end

		if v[p] ~= nil then
			return v[p]
		end

		local v5

		if v4.ServerMiddleware then
			v5 = default2.new(p, v4.ServerMiddleware)
		else
			v5 = default2.new(p)
		end

		CollectionService:AddTag(v5:GetInstance(), "NetDefinitionManaged")

		v[p] = v5

		local globalMiddleware = self.globalMiddleware

		if globalMiddleware ~= nil then
			for i, v6 in ipairs(globalMiddleware) do
				local _ = i - 1
				fn3(v6) -- inferred equivalent call
			end
		end

		return v5
	end
end
function object2:OnFunction(p, p2)
	self:Create(p):SetCallback(p2)
end
function object2:__tostring()
	return self:toString()
end

return { ServerDefinitionBuilder = object2 }