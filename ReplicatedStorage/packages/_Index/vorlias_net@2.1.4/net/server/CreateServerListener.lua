local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local default = RuntimeLib.import(script, script.Parent, "ServerEvent").default
local function isMiddlewareArgument(list): boolean -- 1 equivalent call inferred from this helper
	return #list > 1 and type(list[1]) == "table"
end

local function createServerListener(p, ...)
	local v = { ... }

	if not isMiddlewareArgument(v) then -- inferred equivalent call
		local v2 = v[1]
		return default.new(p):Connect(v2)
	end

	local v2 = v[1]
	local v3 = v[2]
	return default.new(p, v2):Connect(v3)
end

return { default = createServerListener }