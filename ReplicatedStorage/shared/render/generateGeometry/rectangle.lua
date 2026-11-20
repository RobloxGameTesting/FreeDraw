local function rectangle(p)
	return {
		Vector2.zero,
		Vector2.xAxis * p,
		p,
		Vector2.yAxis * p,
		Vector2.zero
	}
end

return rectangle