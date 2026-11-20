local Vector = {}

function Vector.rotate(p, p2: number)
	local v = math.sin(p2)
	local v2 = math.cos(p2)

	return Vector2.new(p.X * v2 + p.Y * v, -p.X * v + p.Y * v2)
end

function Vector.premultiplyRotate(p: number)
	local vector2 = Vector2.new(math.cos(p), -math.sin(p))
	local vector2_2 = Vector2.new(math.sin(p), (math.cos(p)))

	return function(p2)
		return vector2 * p2.X + vector2_2 * p2.Y
	end
end

return Vector