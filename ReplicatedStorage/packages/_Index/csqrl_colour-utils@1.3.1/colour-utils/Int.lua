local Assert = require(script.Parent._Util.Assert)
local ClampColour = require(script.Parent._Util.ClampColour)

local floor = math.floor
local rshift = bit32.rshift
local lshift = bit32.lshift
local band = bit32.band

local function FromInt(p: number)
	Assert.typeOf("FromInt", "int", "number", p)
	local v = floor(p)

	local v2 = band(rshift(v, 16), 255)
	local v3 = band(rshift(v, 8), 255)
	local v4 = band(v, 255)

	return ClampColour(Color3.fromRGB(v2, v3, v4))
end

local function ToInt(color: Color3)
	Assert.typeOf("ToInt", "colour", "Color3", color)

	return lshift(lshift(floor(color.R * 255), 8) + floor(color.G * 255), 8) + floor(color.B * 255)
end

return { fromInt = FromInt, toInt = ToInt }