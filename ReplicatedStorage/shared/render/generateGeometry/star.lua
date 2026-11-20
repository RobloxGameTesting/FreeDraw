local function star(data, p)
	local v = p.polygonVertices * 2
	local magnitude = data.Magnitude
	local v2 = math.atan2(data.X, data.Y)
	local result = {}

	for i = 0, v do
		local v3 = v2 + i / v * 3.141592653589793 * 2
		local v4 = Vector2.new(math.sin(v3), (math.cos(v3))) * magnitude

		if i % 2 == 1 then
			v4 *= p.polygonInnerRadius
		end

		table.insert(result, v4)
	end

	return result
end

return star