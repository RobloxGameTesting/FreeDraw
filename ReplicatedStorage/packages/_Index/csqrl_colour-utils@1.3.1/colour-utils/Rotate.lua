local Assert = require(script.Parent._Util.Assert)
local ClampColour = require(script.Parent._Util.ClampColour)

local prepType = Assert.prepTypeOf("Rotate")
local clamp = math.clamp

return function(color: Color3, p: number)
	prepType("colour", "Color3", color)
	prepType("angle", "number", p)

	local hsv, v, v2 = color:ToHSV()
	local v3 = clamp((hsv + p / 360) % 1, 0, 1)

	return ClampColour((Color3.fromHSV(v3, v, v2)))
end