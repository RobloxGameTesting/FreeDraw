local parent = script.Parent.Parent

local Util = require(parent.Util)

local function count(list, callback)
	local count2 = 0

	if type(callback) ~= "function" then
		callback = Util.func.truthy
	end

	for i, item in ipairs(list) do
		if callback(item, i, list) then
			count2 += 1
		end
	end

	return count2
end

return count