local _Filter = require(script.Parent._Filter)

return _Filter("Overlay", function(p: number, p2: number)
	local v = p * 255
	local v2 = p2 * 255

	return v < 128 and v2 * 2 * v / 255 or 255 - (255 - v) * 2 * (255 - v2) / 255
end)