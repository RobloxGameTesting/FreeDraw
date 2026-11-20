local Assert = require(script.Parent.Parent._Util.Assert)
local Constants = require(script.Parent.Constants)

local function RGB_XYZ(p: number) -- 3 equivalent calls inferred from this helper
	if p <= 0.04045 then
		return p / 12.92
	end

	return ((p + 0.055) / 1.055) ^ 2.4
end

local function XYZ_LAB(p: number) -- 3 equivalent calls inferred from this helper
	if Constants.t3 < p then
		return p ^ (1 / 3)
	end

	return p / Constants.t2 + Constants.t0
end

local function ToVector3(color: Color3)
	local v = RGB_XYZ(color.R) -- inferred equivalent call
	local v2 = RGB_XYZ(color.G) -- inferred equivalent call
	local v3 = RGB_XYZ(color.B) -- inferred equivalent call

	return (Vector3.new(
		XYZ_LAB((v * 0.4124564 + v2 * 0.3575761 + v3 * 0.1804375) / Constants.Xn), -- inferred equivalent call
		XYZ_LAB((v * 0.2126729 + v2 * 0.7151522 + v3 * 0.072175) / Constants.Yn), -- inferred equivalent call
		XYZ_LAB((v * 0.0193339 + v2 * 0.119192 + v3 * 0.9503041) / Constants.Zn) -- inferred equivalent call
	))
end

local function ToLAB(color: Color3)
	Assert.typeOf("ToLAB", "colour", "Color3", color)

	local toVector3 = ToVector3(color)
	local v = toVector3.Y * 116 - 16

	return {
		L = v < 0 and 0 or v,
		A = (toVector3.X - toVector3.Y) * 500,
		B = (toVector3.Y - toVector3.Z) * 200
	}
end

return ToLAB