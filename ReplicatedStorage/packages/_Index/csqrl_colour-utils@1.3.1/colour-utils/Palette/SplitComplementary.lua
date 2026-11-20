require(script.Parent.Parent._Util.Types)
local Assert = require(script.Parent.Parent._Util.Assert)
local Rotate = require(script.Parent.Parent.Rotate)

local prepType = Assert.prepTypeOf("SplitComplementary")

return function(color: Color3)
	prepType("base", "Color3", color)

	return { Rotate(color, 150), Rotate(color, 210) }
end