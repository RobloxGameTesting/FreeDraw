local Enum2 = require(script.Parent.Enum)
local Configs = require(script.Configs)

local function RGBtoXYZ(color: Color3)
	local RGB_XYZ = Configs.Matrix.RGB_XYZ

	local r = color.R
	local g = color.G
	local b = color.B
	local v

	if r > 0.04 then
		v = ((r + 0.055) / 1.055) ^ 2.4
	else
		v = r / 12.92
	end

	local v2

	if g > 0.04 then
		v2 = ((g + 0.055) / 1.055) ^ 2.4
	else
		v2 = g / 12.92
	end

	local v3

	if b > 0.04 then
		v3 = ((b + 0.055) / 1.055) ^ 2.4
	else
		v3 = b / 12.92
	end

	return (Vector3.new(
		v * RGB_XYZ[1] + v2 * RGB_XYZ[4] + v3 * RGB_XYZ[7],
		v * RGB_XYZ[2] + v2 * RGB_XYZ[5] + v3 * RGB_XYZ[8],
		v * RGB_XYZ[3] + v2 * RGB_XYZ[6] + v3 * RGB_XYZ[9]
	))
end

local function XYZtoXyY(vector3: Vector3)
	local v = vector3.X + vector3.Y + vector3.Z

	if v == 0 then
		return { X = 0, y = 0, Y = vector3.Y }
	end

	return {
		X = vector3.X / v,
		y = vector3.Y / v,
		Y = vector3.Y
	}
end

local function Anomalise(color: Color3, color2: Color3, value: number?)
	local v = type(value) ~= "number" and 1.75 or value

	local v2 = v + 1

	return Color3.new((v * color2.R + color.R) / v2, (v * color2.G + color.G) / v2, (v * color2.B + color.B) / v2)
end

local function SimulateBlinder(color: Color3, value: number)
	assert(typeof(color) == "Color3", "Colour must be a Color3")
	assert(typeof(value) == "number", "Blinder must be a number (see Enums.Blind)")

	local group = Configs.Groups[value]
	local v = Configs.Anomalised[value]

	if group == Enum2.Group.Trichroma then
		return color
	end

	if group == Enum2.Group.Achroma then
		local v2 = color.R * 0.213 + color.G * 0.715 + color.B * 0.072
		local color2 = Color3.new(v2, v2, v2)

		if v then
			return Anomalise(color, color2)
		end

		return color2
	else
		local v2 = Configs.Blinder[group]
		local xYZtoXyY = XYZtoXyY(RGBtoXYZ(color))

		local v3 = (xYZtoXyY.y - v2.Y) / (xYZtoXyY.X - v2.X)
		local v4 = xYZtoXyY.y - xYZtoXyY.X * v3

		local v5 = (v2.YI - v4) / (v3 - v2.M)
		local v6 = v3 * v5 + v4

		local v7 = {
			X = v5 * xYZtoXyY.Y / v6,
			Y = xYZtoXyY.Y,
			Z = (1 - (v5 + v6)) * xYZtoXyY.Y / v6
		}

		local v8 = xYZtoXyY.Y * 0.313 / 0.329
		local v9 = xYZtoXyY.Y * 0.358 / 0.329 - v7.Z
		local v10 = v8 - v7.X

		local XYZ_RGB = Configs.Matrix.XYZ_RGB

		local v11 = v10 * XYZ_RGB[1] + 0 * XYZ_RGB[4] + v9 * XYZ_RGB[7]
		local v12 = v10 * XYZ_RGB[2] + 0 * XYZ_RGB[5] + v9 * XYZ_RGB[8]
		local v13 = v10 * XYZ_RGB[3] + 0 * XYZ_RGB[6] + v9 * XYZ_RGB[9]

		v7.R = v7.X * XYZ_RGB[1] + v7.Y * XYZ_RGB[4] + v7.Z * XYZ_RGB[7]
		v7.G = v7.X * XYZ_RGB[2] + v7.Y * XYZ_RGB[5] + v7.Z * XYZ_RGB[8]
		v7.B = v7.X * XYZ_RGB[3] + v7.Y * XYZ_RGB[6] + v7.Z * XYZ_RGB[9]

		local v14 = ((v7.R < 0 and 0 or 1) - v7.R) / v11
		local v15 = ((v7.G < 0 and 0 or 1) - v7.G) / v12
		local v16 = ((v7.B < 0 and 0 or 1) - v7.B) / v13

		local v17 = (v14 > 1 or v14 < 0) and 0 or v14
		local v18 = (v15 > 1 or v15 < 0) and 0 or v15
		local v19 = (v16 > 1 or v16 < 0) and 0 or v16

		if not (v18 < v17) then
			v17 = v18
		end

		if v17 < v19 then
			v17 = v19
		end

		v7.R += v17 * v11
		v7.G += v17 * v12
		v7.B += v17 * v13

		v7.R = 255 * (v7.R <= 0 and 0 or v7.R >= 1 and 1 or v7.R ^ (1 / Configs.Gamma_Correct))
		v7.G = 255 * (v7.G <= 0 and 0 or v7.G >= 1 and 1 or v7.G ^ (1 / Configs.Gamma_Correct))
		v7.B = 255 * (v7.B <= 0 and 0 or v7.B >= 1 and 1 or v7.B ^ (1 / Configs.Gamma_Correct))

		local color2 = Color3.fromRGB(v7.R or 0, v7.G or 0, v7.B or 0)

		if v then
			return Anomalise(color, color2)
		end

		return color2
	end
end

return SimulateBlinder