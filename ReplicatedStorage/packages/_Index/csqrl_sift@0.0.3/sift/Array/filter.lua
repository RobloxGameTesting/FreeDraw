local parent = script.Parent.Parent

local Util = require(parent.Util)

local function filter(list, callback)
	local result = {}

	if type(callback) ~= "function" then
		callback = Util.func.truthy
	end

	for i, item in ipairs(list) do
		if callback(item, i, list) then
			table.insert(result, item)
		end
	end

	return result
end

return filter