require(script.Parent.Parent._Util.Types)
local Assert = require(script.Parent.Parent._Util.Assert)
local Array = require(script.Parent.Parent._Util.Array)

local HSL = require(script.Parent.Parent.HSL)
local Saturate = require(script.Parent.Parent.Saturate)

local prepType = Assert.prepTypeOf("Tailwind")

local find = table.find
local abs = math.abs

local v = {
	0.95,
	0.85,
	0.75,
	0.65,
	0.55,
	0.45,
	0.35,
	0.25,
	0.15,
	0.05
}
local v2 = {
	0.32,
	0.16,
	0.08,
	0.04,
	0,
	0,
	0.04,
	0.08,
	0.16,
	0.32
}

local function GetBaseColourSaturationIndex(hsl) -- 1 equivalent call inferred from this helper
	local v3 = hsl.L / 100

	return find(v, (Array.reduce(v, function(p, p2)
		return if abs(p2 - v3) < abs(p - v3) then p2 else p
	end)))
end

local function Tailwind(color: Color3)
	prepType("base", "Color3", color)

	local hsl = HSL.toHSL(color)
	local baseColourSaturationIndex = GetBaseColourSaturationIndex(hsl) -- inferred equivalent call
	local mapped = Array.map(Array.map(v, function(p: number)
		return HSL.fromHSL({
			H = hsl.H,
			S = hsl.S,
			L = p * 100
		})
	end), function(color2: Color3, p)
		return Saturate(color2, v2[p] - v2[baseColourSaturationIndex])
	end)

	return Array.reduce(mapped, function(p, color2: Color3, p2)
		p[p2 == 1 and 50 or (p2 - 1) * 100] = color2

		return p
	end, {})
end

return Tailwind