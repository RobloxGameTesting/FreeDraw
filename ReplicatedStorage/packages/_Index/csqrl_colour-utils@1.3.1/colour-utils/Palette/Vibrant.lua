require(script.Parent.Parent._Util.Types)
local Assert = require(script.Parent.Parent._Util.Assert)
local Schema = require(script.Parent.Parent._Util.Schema)
local GetLuminance = require(script.Parent.Parent.GetLuminance)

local prepArray = Assert.prepArrayOf("Vibrant")

local abs = math.abs
local sqrt = math.sqrt
local toHSV = Color3.toHSV

local v = { TargetLuminance = 0.49, TargetSaturation = 1, TargetValue = 0.8 }

return function(list, p)
	prepArray("swatches", "Color3", list)

	local loose = Schema.Loose(v, p)
	local v2 = 1e999
	local v3 = nil

	for _, item in ipairs(list) do
		local _, v4, v5 = toHSV(item)
		local luminance = GetLuminance(item)

		local v6 = abs(v4 - loose.TargetSaturation)
		local v7 = abs(v5 - loose.TargetValue)
		local v8 = abs(luminance - loose.TargetLuminance)

		local v9 = sqrt(v6 ^ 2 + v7 ^ 2 + v8 ^ 2)

		if not (v9 < v2) then
			continue
		end

		v3 = item
		v2 = v9
	end

	return v3
end