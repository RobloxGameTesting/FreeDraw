local Assert = require(script.Parent.Parent._Util.Assert)
local isNaN = require(script.Parent.Parent._Util.isNaN)

local Constants = require(script.Parent.Constants)

local function XYZ_RGB(p: number) -- 3 equivalent calls inferred from this helper
	local v

	if p <= 0.00304 then
		v = p * 12.92
	else
		v = p ^ (5 / 12) * 1.055 - 0.055
	end

	return v * 255
end

local function LAB_XYZ(p: number) -- 3 equivalent calls inferred from this helper
	if Constants.t1 < p then
		return p ^ 3
	end

	return Constants.t2 * (p - Constants.t0)
end

local function FromLAB(data)
	Assert.typeOf("FromLAB", "lab", "table", data)

	Assert.typeOf("FromLAB", "lab.L", "number", data.L)
	Assert.typeOf("FromLAB", "lab.A", "number", data.A)
	Assert.typeOf("FromLAB", "lab.B", "number", data.B)

	local v = (data.L + 16) / 116
	local v2

	if isNaN(data.A) then
		v2 = v
	else
		v2 = v + data.A / 500
	end

	local v3

	if isNaN(data.B) then
		v3 = v
	else
		v3 = v - data.B / 200
	end

	local v4 = Constants.Yn * LAB_XYZ(v) -- inferred equivalent call
	local v5 = Constants.Xn * LAB_XYZ(v2) -- inferred equivalent call
	local v6 = Constants.Zn * LAB_XYZ(v3) -- inferred equivalent call

	return Color3.fromRGB(
		XYZ_RGB(3.2404542 * v5 - 1.5371385 * v4 - 0.4985314 * v6), -- inferred equivalent call
		XYZ_RGB(-0.969266 * v5 + 1.8760108 * v4 + 0.041556 * v6), -- inferred equivalent call
		XYZ_RGB(0.0556434 * v5 - 0.2040259 * v4 + 1.0572252 * v6) -- inferred equivalent call
	)
end

return FromLAB