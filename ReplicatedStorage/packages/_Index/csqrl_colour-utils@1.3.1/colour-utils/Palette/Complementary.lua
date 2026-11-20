require(script.Parent.Parent._Util.Types)
local Assert = require(script.Parent.Parent._Util.Assert)
local Rotate = require(script.Parent.Parent.Rotate)

local prepType = Assert.prepTypeOf("Complementary")

return function(color: Color3)
	prepType("base", "Color3", color)

	return { Rotate(color, 180) }
end