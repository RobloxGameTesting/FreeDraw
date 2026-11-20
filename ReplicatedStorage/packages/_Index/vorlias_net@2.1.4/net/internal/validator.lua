local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local isMixed = RuntimeLib.import(script, script.Parent, "tables").isMixed
game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local isSerializable = nil
local function validateArguments(...)
	for i, v in ipairs({ ... }) do
		if not isSerializable.check(v) then
			error(string.format(isSerializable.errorMessage, i), 2)
		end

		if typeof(v) ~= "Instance" then
			continue
		end

		if v:IsDescendantOf(ServerStorage) or v:IsDescendantOf(ServerScriptService) then
			error("[rbx-net] Instance at argument #" .. tostring(i) .. " is inside a server-only container and cannot be sent via remotes.")
		end

		if not v:IsDescendantOf(game) then
			error("[rbx-net] Instance at argument #" .. tostring(i) .. " is not a valid descendant of game, and wont replicate")
		end
	end
end

isSerializable = {
	errorMessage = "Argument #%d is not serializable. - see http://docs.vorlias.com/rbx-net/docs/2.0/serialization",
	check = function(value): boolean
		if type(value) == "function" or type(value) == "thread" then
			return false
		end

		if type(value) == "table" and getmetatable(value) ~= nil then
			return false
		end

		return type(value) ~= "table" or not isMixed(value)
	end
}

return {
	validateArguments = validateArguments,
	oneOf = function(...)
		local v = { ... }

		local v2 = ", "
		local v4 = v2 == nil and ", " or v2
		local v3 = {
			errorMessage = "Expected one of: " .. table.concat(v, v4)
		}
		function v3.check(value): boolean
			if type(value) ~= "string" then
				return false
			end

			for _, v5 in ipairs(v) do
				if value == v5 then
					return true
				end
			end

			return false
		end

		return v3
	end,
	isSerializable = isSerializable
}