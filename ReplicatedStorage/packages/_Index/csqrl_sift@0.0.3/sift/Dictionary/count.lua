local parent = script.Parent.Parent

local Util = require(parent.Util)

local function count(items, callback)
	local count2 = 0

	if type(callback) ~= "function" then
		callback = Util.func.truthy
	end

	for k, item in pairs(items) do
		if callback(item, k, items) then
			count2 += 1
		end
	end

	return count2
end

return count