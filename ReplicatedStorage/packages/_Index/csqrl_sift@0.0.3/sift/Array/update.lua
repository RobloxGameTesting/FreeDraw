local parent = script.Parent.Parent

local Util = require(parent.Util)
local copy = require(script.Parent.copy)

local function call(callback, total: number) -- 1 equivalent call inferred from this helper
	if type(callback) == "function" then
		return callback(total)
	end
end

local function update(list, total: number, callback, callback2)
	local v = #list
	local v2 = copy(list)

	if total < 1 then
		total += v
	end

	if type(callback) ~= "function" then
		callback = Util.func.returned
	end

	if v2[total] ~= nil then
		v2[total] = callback(v2[total], total)
		return v2
	end

	v2[total] = call(callback2, total) -- inferred equivalent call
	return v2
end

return update