local Assert = require(script.Parent.Parent._Util.Assert)
local LAB = require(script.Parent.Parent.LAB)

local Constants = require(script.Parent.Constants)

local round = math.round
local atan2 = math.atan2
local sqrt = math.sqrt

local function LABtoLCH(data)
	local v = sqrt(data.A ^ 2 + data.B ^ 2)
	local v2 = (atan2(data.B, data.A) * Constants.RAD_DEG + 360) % 360

	if round(v * 10000) == 0 then
		v2 = Constants.NaN
	end

	return { L = data.L, C = v, H = v2 }
end

local function ToLCH(color: Color3)
	Assert.typeOf("ToLCH", "colour", "Color3", color)

	return LABtoLCH(LAB.toLAB(color))
end

return ToLCH