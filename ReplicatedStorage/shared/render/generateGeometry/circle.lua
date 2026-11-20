local polygon = require(script.Parent.polygon)

local function circle(p)
	local v = math.ceil((1 - (1 - math.clamp(0.5 * (p.Magnitude * 3.141592653589793), 0, 80) / 80) ^ 5) * 80)

	return polygon(p, {
		polygonVertices = math.min(v + 5, 500)
	})
end

return circle