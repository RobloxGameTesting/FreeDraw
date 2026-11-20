local Assert = require(script.Parent._Util.Assert)

local round = math.round
local floor = math.floor
local clamp = math.clamp
local min = math.min
local max = math.max
local abs = math.abs

local function ToHSL(color: Color3)
	Assert.typeOf("ToHSL", "colour", "Color3", color)

	local v = min(color.R, color.G, color.B)
	local v2 = max(color.R, color.G, color.B)
	local v3 = v2 - v

	local midpoint = (v2 + v) / 2
	local v4

	if v3 == 0 then
		v4 = 0
	else
		v4 = v3 / (1 - abs(midpoint * 2 - 1))
	end

	local v5

	if v3 == 0 then
		v5 = 0
	elseif v2 == color.R then
		v5 = (color.G - color.B) / v3 % 6
	elseif v2 == color.G then
		v5 = (color.B - color.R) / v3 + 2
	else
		v5 = (color.R - color.G) / v3 + 4
	end

	local v6 = round(v5 * 60)

	if v6 < 0 then
		v6 += 360
	end

	return {
		H = v6,
		S = clamp(abs((round(v4 * 100))), 0, 100),
		L = clamp(abs((round(midpoint * 100))), 0, 100)
	}
end

local function FromHSL(data)
	Assert.typeOf("FromHSL", "hsl", "table", data)

	Assert.typeOf("FromHSL", "hsl.H", "number", data.H)
	Assert.typeOf("FromHSL", "hsl.S", "number", data.S)
	Assert.typeOf("FromHSL", "hsl.L", "number", data.L)

	local v = data.S / 100
	local v2 = data.L / 100

	local v3 = (1 - abs(v2 * 2 - 1)) * v
	local v4 = v3 * (1 - abs(data.H / 60 % 2 - 1))
	local v5 = v2 - v3 / 2

	local v6 = 0
	local v7 = 0
	local v8 = 0

	if data.H >= 0 and data.H < 60 then
		v7 = v4
		v6 = v3
		v8 = 0
	elseif data.H >= 60 and data.H < 120 then
		v7 = v3
		v6 = v4
		v8 = 0
	elseif data.H >= 120 and data.H < 180 then
		v8 = v4
		v7 = v3
		v6 = 0
	elseif data.H >= 180 and data.H < 240 then
		v8 = v3
		v7 = v4
		v6 = 0
	elseif data.H >= 240 and data.H < 300 then
		v8 = v3
		v6 = v4
		v7 = 0
	elseif data.H >= 300 and data.H < 360 then
		v8 = v4
		v6 = v3
		v7 = 0
	end

	local v9 = min(floor((v6 + v5) * 255), 255)
	local v10 = min(floor((v7 + v5) * 255), 255)
	local v11 = min(floor((v8 + v5) * 255), 255)

	return Color3.fromRGB(v9, v10, v11)
end

return { fromHSL = FromHSL, toHSL = ToHSL }