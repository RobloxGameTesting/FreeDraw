local Assert = require(script.Parent.Parent._Util.Assert)
local prepType = Assert.prepTypeOf("GetContrastRatio")

local GetLuminance = require(script.Parent.Parent.GetLuminance)

local max = math.max
local min = math.min

return function(color: Color3, color2: Color3)
	prepType("foreground", "Color3", color)
	prepType("background", "Color3", color2)

	local luminance = GetLuminance(color)
	local luminance2 = GetLuminance(color2)

	return (max(luminance, luminance2) + 0.05) / (min(luminance, luminance2) + 0.05)
end