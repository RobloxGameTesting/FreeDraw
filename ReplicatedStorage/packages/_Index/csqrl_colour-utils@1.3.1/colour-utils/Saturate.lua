local Assert = require(script.Parent._Util.Assert)
local ClampColour = require(script.Parent._Util.ClampColour)

local prepType = Assert.prepTypeOf("Saturate")

local clamp = math.clamp

return function(color: Color3, p: number)
	prepType("colour", "Color3", color)
	prepType("coefficient", "number", p)

	local hsv, v, v2 = color:ToHSV()
	local v3 = v + v * p

	return ClampColour(Color3.fromHSV(hsv, clamp(v3, 0, 1), v2))
end