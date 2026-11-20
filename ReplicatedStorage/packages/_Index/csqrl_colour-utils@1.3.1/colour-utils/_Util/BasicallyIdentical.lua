local format = string.format
local abs = math.abs

local function StringifyColor3(color: Color3) -- 2 equivalent calls inferred from this helper
	return string.format("Color3<%.3g, %.3g, %.3g> \"#%s\"", color.R * 255, color.G * 255, color.B * 255, color:ToHex())
end

return function(color: Color3, color2: Color3, value: number?)
	local v = type(value) ~= "number" and 0.005 or value

	assert(typeof(color) == "Color3", "\"Base\" is not a Color3")
	assert(typeof(color2) == "Color3", "\"Compare\" is not a Color3")

	local v2 = abs(color.R - color2.R)
	local v3 = abs(color.G - color2.G)
	local v4 = abs(color.B - color2.B)
	local v5

	if v2 <= v and v3 <= v then
		v5 = v4 <= v
	else
		v5 = false
	end

	if v5 then
		return v5
	end

	local v6 = {}

	if v < v2 then
		local v7 = v - v2
		table.insert(v6, format("R was out by %.3g", (tostring((abs(v7))))))
	end

	if v < v3 then
		local v7 = v - v3
		table.insert(v6, format("G was out by %.3g", (tostring((abs(v7))))))
	end

	if v < v4 then
		local v7 = v - v4
		table.insert(v6, format("B was out by %.3g", (tostring((abs(v7))))))
	end

	error(
		format(
			"Expected %s (%s) to be within %s, got %s (%s) instead; %s",
			StringifyColor3(color), -- inferred equivalent call
			typeof(color),
			tostring(v),
			StringifyColor3(color2), -- inferred equivalent call
			typeof(color2),
			table.concat(v6, ", ")
		),
		2
	)

	return v5
end