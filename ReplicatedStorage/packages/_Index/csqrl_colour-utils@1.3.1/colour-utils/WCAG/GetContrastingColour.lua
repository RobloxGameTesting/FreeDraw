local Assert = require(script.Parent.Parent._Util.Assert)
local prepType = Assert.prepTypeOf("GetContrastingColour")

local GetContrastRatio = require(script.Parent.GetContrastRatio)
local Lighten = require(script.Parent.Parent.Lighten)
local Darken = require(script.Parent.Parent.Darken)
local isDark = require(script.Parent.Parent.isDark)

return function(color: Color3, color2: Color3, value: number?)
	prepType("foreground", "Color3", color)
	prepType("background", "Color3", color2)

	local v = type(value) ~= "number" and 4.5 or value

	local contrastRatio = GetContrastRatio(color, color2)

	if v <= contrastRatio then
		return color
	end

	if isDark(color2) then
		return Lighten(color, (v - contrastRatio) / v)
	end

	return Darken(color, (v - contrastRatio) / v)
end