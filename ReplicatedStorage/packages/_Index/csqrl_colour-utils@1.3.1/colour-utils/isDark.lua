local Assert = require(script.Parent._Util.Assert)
local prepType = Assert.prepTypeOf("isDark")

local GetLuminance = require(script.Parent.GetLuminance)

return function(color: Color3): boolean
	prepType("colour", "Color3", color)

	return GetLuminance(color) < 0.5
end