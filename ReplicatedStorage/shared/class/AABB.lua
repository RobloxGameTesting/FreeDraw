local function createAABB()
	local vector2 = Vector2.new(1e999, 1e999)
	local vector2_2 = Vector2.new(-1e999, -1e999)
	local flag = false

	return {
		add = function(p)
			vector2 = vector2:Min(p)
			vector2_2 = vector2_2:Max(p)
			flag = true
		end,
		getBounds = function()
			if flag then
				return vector2, vector2_2
			end

			return Vector2.zero, Vector2.zero
		end
	}
end

return { new = createAABB }