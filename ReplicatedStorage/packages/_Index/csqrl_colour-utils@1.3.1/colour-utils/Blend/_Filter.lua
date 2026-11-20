local ClampColour = require(script.Parent.Parent._Util.ClampColour)
local Assert = require(script.Parent.Parent._Util.Assert)

return function(p: string, callback)
	local prepType = Assert.prepTypeOf(p)

	return function(color: Color3, color2: Color3)
		prepType("background", "Color3", color)
		prepType("foreground", "Color3", color2)

		return ClampColour((Color3.fromRGB(
			callback(color.R, color2.R),
			callback(color.G, color2.G),
			callback(color.B, color2.B)
		)))
	end
end