local Assert = require(script.Parent._Util.Assert)
local prepType = Assert.prepTypeOf("Darken")

local ClampColour = require(script.Parent._Util.ClampColour)

return function(color: Color3, p: number)
	prepType("colour", "Color3", color)
	prepType("coefficient", "number", p)

	return ClampColour(color:Lerp(Color3.new(), p))
end