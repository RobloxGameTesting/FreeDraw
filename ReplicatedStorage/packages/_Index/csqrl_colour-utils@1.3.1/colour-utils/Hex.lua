local Assert = require(script.Parent._Util.Assert)
local ClampColour = require(script.Parent._Util.ClampColour)
local Transparency = require(script.Parent.Blend.Transparency)

local sub = string.sub
local gsub = string.gsub
local format = string.format
local rep = string.rep
local split = string.split

local color = Color3.new()

local function FromHex(value: string)
	Assert.typeOf("FromHex", "hex", "string", value)

	local v = gsub(value, "[^A-Fa-f0-9]", "")

	if #v == 3 then
		local v2 = split(v, "")
		v = ""

		for _, v3 in ipairs(v2) do
			v ..= rep(v3, 2)
		end
	elseif #v < 6 then
		v = format("%s%s", v, rep(v, 6 - #v))
	end

	local v2 = tonumber(sub(v, 1, 2), 16)
	local v3 = tonumber(sub(v, 3, 4), 16)
	local v4 = tonumber(sub(v, 5, 6), 16)

	return ClampColour(Color3.fromRGB(v2, v3, v4))
end

local function FromHexRGBA(value: string, color2: Color3?)
	Assert.typeOf("FromHexRGBA", "hex", "string", value)

	local v = gsub(value, "[^A-Fa-f0-9]", "")

	if #v < 8 then
		return FromHex(v)
	end

	local v2 = 1 - tonumber(sub(v, -2), 16) / 255
	return Transparency(FromHex(sub(v, 1, -3)), color2 or color, v2)
end

local function ToHex(color2: Color3)
	Assert.typeOf("ToHex", "colour", "Color3", color2)

	return (format("%.2x%.2x%.2x", color2.R * 255, color2.G * 255, color2.B * 255))
end

return { fromHex = FromHex, fromHexRGBA = FromHexRGBA, toHex = ToHex }