local parent = script.Parent.Parent

local Util = require(parent.Util)

local function filter(items, callback)
	local result = {}

	if type(callback) ~= "function" then
		callback = Util.func.truthy
	end

	for k, item in pairs(items) do
		if callback(item, k, items) then
			result[k] = item
		end
	end

	return result
end

return filter