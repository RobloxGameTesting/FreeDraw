local toSet = require(script.Parent.toSet)

local function removeValues(list, ...)
	local v = toSet({ ... })
	local result = {}

	for _, item in ipairs(list) do
		if not v[item] then
			table.insert(result, item)
		end
	end

	return result
end

return removeValues