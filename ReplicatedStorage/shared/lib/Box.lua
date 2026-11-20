local vector2 = Vector2.new(1e999, 1e999)
local v = -vector2
local function bounds(list)
	local count = #list

	if count <= 4096 then
		return Rect.new(vector2:Min(table.unpack(list)), v:Max(table.unpack(list)))
	end

	local v2 = table.create(math.ceil(count / 4096) * 2)

	for i = 1, count, 4096 do
		local v3 = math.min(i + 4096 - 1, count)

		table.insert(v2, vector2:Min(table.unpack(list, i, v3)))
		table.insert(v2, v:Max(table.unpack(list, i, v3)))
	end

	return bounds(v2)
end

return {
	bounds = bounds,
	expand = function(rect: Rect, p: number)
		local vector2_2 = Vector2.new(p, p)

		return Rect.new(rect.Min - vector2_2, rect.Max + vector2_2)
	end
}