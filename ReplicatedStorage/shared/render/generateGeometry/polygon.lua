local function polygon(data, p)
	local polygonVertices = p.polygonVertices
	local magnitude = data.Magnitude
	local v = math.atan2(data.X, data.Y)
	local result = {}

	for i = 0, polygonVertices do
		local v2 = v + i / polygonVertices * 3.141592653589793 * 2
		table.insert(result, Vector2.new(math.sin(v2), (math.cos(v2))) * magnitude)
	end

	return result
end

return polygon