local Assert = require(script.Parent._Util.Assert)
local Saturate = require(script.Parent.Saturate)

local prepType = Assert.prepTypeOf("Saturate")

return function(color: Color3, p: number)
	prepType("colour", "Color3", color)
	prepType("coefficient", "number", p)

	return Saturate(color, -p)
end