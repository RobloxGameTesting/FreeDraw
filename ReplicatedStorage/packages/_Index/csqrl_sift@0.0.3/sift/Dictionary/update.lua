local copy = require(script.Parent.copy)

local function call(callback, p) -- 1 equivalent call inferred from this helper
	if type(callback) == "function" then
		return callback(p)
	end
end

local function update(p, p2, callback, callback2)
	local v = copy(p)

	if v[p2] == nil then
		if callback2 then
			v[p2] = call(callback2, p2) -- inferred equivalent call
		end
	elseif callback then
		v[p2] = callback(v[p2], p2)
		return v
	end

	return v
end

return update