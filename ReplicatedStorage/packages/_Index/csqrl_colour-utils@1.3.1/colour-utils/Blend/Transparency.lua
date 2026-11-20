local function applyTransparency(color: Color3, color2: Color3, p: number)
	local v = 1 - p

	local v2 = color2.R * v + color.R * p
	local v3 = color2.G * v + color.G * p
	local v4 = color2.B * v + color.B * p

	return Color3.new(v2, v3, v4)
end

return applyTransparency