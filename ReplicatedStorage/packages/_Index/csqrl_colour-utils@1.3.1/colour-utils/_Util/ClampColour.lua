local clamp = math.clamp

return function(color: Color3)
	local v = clamp(color.R, 0, 1)
	local v2 = clamp(color.G, 0, 1)
	local v3 = clamp(color.B, 0, 1)

	return Color3.new(v, v2, v3)
end