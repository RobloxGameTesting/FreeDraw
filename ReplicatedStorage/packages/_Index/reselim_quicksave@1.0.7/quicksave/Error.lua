local makeEnum = require(script.Parent.makeEnum)
local makeEnum2 = makeEnum.makeEnum
local getTime = require(script.Parent.getTime)
local getTime2 = getTime.getTime

local Error = {
	Kind = makeEnum2("Quicksave.Error.Kind", {
		"DataStoreError",
		"CouldNotAcquireLock",
		"LockConsistencyViolation",
		"SchemaValidationFailed"
	})
}

Error.__index = Error

function Error.new(options, parent)
	local v = options or {}
	return (setmetatable({
		error = tostring(v.error) or "[This error has no error text.]",
		trace = v.trace,
		context = v.context,
		kind = v.kind,
		parent = parent,
		createdTick = getTime2(),
		createdTrace = debug.traceback()
	}, Error))
end

function Error.is(p): boolean
	if type(p) ~= "table" then
		return false
	end

	local metatable = getmetatable(p)

	if type(metatable) == "table" then
		return rawget(p, "error") ~= nil and type((rawget(metatable, "extend"))) == "function"
	end

	return false
end

function Error.isKind(p, p2)
	assert(p2 ~= nil, "Argument #2 to Quicksave.Error.isKind must not be nil")

	return Error.is(p) and p.kind == p2
end

function Error.extend(p, options)
	local v = options or {}

	v.kind = v.kind or p.kind

	return Error.new(v, p)
end

function Error:getErrorChain()
	local parents = { self }

	while parents[#parents].parent do
		table.insert(parents, parents[#parents].parent)
	end

	return parents
end

function Error:__tostring()
	local values = { string.format("-- Quicksave.Error(%s) --", self.kind or "?") }

	for _, v in ipairs(self:getErrorChain()) do
		table.insert(values, table.concat({ v.trace or v.error, v.context }, "\n"))
	end

	return table.concat(values, "\n")
end

return Error