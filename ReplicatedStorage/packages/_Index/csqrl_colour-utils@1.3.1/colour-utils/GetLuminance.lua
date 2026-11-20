local Assert = require(script.Parent._Util.Assert)

local prepType = Assert.prepTypeOf("GetLuminance")

local function transformValue(p: number) -- 3 equivalent calls inferred from this helper
	return p <= 0.03928 and p / 12.92 or ((p + 0.055) / 1.055) ^ 2.4
end

return function(color: Color3)
	prepType("colour", "Color3", color)

	local v = transformValue(color.R) -- inferred equivalent call
	local v2 = transformValue(color.G) -- inferred equivalent call
	local v3 = transformValue(color.B) -- inferred equivalent call

	return v * 0.2126 + v2 * 0.7152 + v3 * 0.0722
end