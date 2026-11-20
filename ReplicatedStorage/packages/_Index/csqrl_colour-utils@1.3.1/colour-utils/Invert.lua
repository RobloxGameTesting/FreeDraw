local ClampColour = require(script.Parent._Util.ClampColour)
local Assert = require(script.Parent._Util.Assert)
local prepType = Assert.prepTypeOf("Invert")

return function(color: Color3)
	prepType("colour", "Color3", color)

	return ClampColour((Color3.new(1 - color.R, 1 - color.G, 1 - color.B)))
end