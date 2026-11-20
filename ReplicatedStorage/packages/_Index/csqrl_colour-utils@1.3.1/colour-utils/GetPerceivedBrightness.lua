local Assert = require(script.Parent._Util.Assert)

local prepType = Assert.prepTypeOf("GetPerceivedBrightness")

return function(color: Color3)
	prepType("colour", "Color3", color)

	local v = color.R * 255
	local v2 = color.G * 255
	local v3 = color.B * 255

	return (v * 299 + v2 * 587 + v3 * 114) / 1000 / 255
end