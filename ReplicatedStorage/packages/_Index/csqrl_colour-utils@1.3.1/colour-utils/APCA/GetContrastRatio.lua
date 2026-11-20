local Assert = require(script.Parent.Parent._Util.Assert)
local Const = require(script.Parent.Const)

local prepType = Assert.prepTypeOf("GetContrastRatioAPCA")

local abs = math.abs

local function ComputePower(p: number) -- 3 equivalent calls inferred from this helper
	return p ^ Const.SRGB_TRC
end

local function ComputeY(color: Color3) -- 2 equivalent calls inferred from this helper
	return ComputePower(color.R) * Const.RED_COEF + ComputePower(color.G) * Const.GREEN_COEF + ComputePower(color.B) * Const.BLUE_COEF -- inferred equivalent call
end

local function SoftClampBlack(p: number) -- 2 equivalent calls inferred from this helper
	if Const.BLK_THRS < p then
		return p
	end

	return p + abs(p - Const.BLK_THRS) ^ Const.BLK_CLMP
end

local function GetContrastRatio(color: Color3, color2: Color3)
	prepType("foreground", "Color3", color)
	prepType("background", "Color3", color2)
	local softClampBlack = SoftClampBlack(ComputeY(color)) -- inferred equivalent call
	local softClampBlack2 = SoftClampBlack(ComputeY(color2)) -- inferred equivalent call

	if abs(softClampBlack2 - softClampBlack) < Const.MIN_DELTA_Y then
		return 0
	end

	local v

	if softClampBlack < softClampBlack2 then
		local v2 = (softClampBlack2 ^ Const.NORM_BG_EXP - softClampBlack ^ Const.NORM_FG_EXP) * Const.SCALE_BOW

		if v2 < Const.LOW_CLIP then
			v = 0
		elseif v2 < Const.LOW_BOW_THRS then
			v = v2 - v2 * Const.LOW_BOW_FACTOR * Const.LOW_BOW_OFFS
		else
			v = v2 - Const.LOW_BOW_OFFS
		end
	else
		local v2 = (softClampBlack2 ^ Const.REV_BG_EXP - softClampBlack ^ Const.REV_FG_EXP) * Const.SCALE_WOB

		if -Const.LOW_CLIP < v2 then
			v = 0
		elseif -Const.LOW_WOB_THRS < v2 then
			v = v2 - v2 * Const.LOW_WOB_FACTOR * Const.LOW_WOB_OFFS
		else
			v = v2 + Const.LOW_WOB_OFFS
		end
	end

	return v * 100
end

return GetContrastRatio