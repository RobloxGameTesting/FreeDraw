local Assert = require(script.Parent.Parent._Util.Assert)

local prepType = Assert.prepTypeOf("Monochromatic")
local prepEvalArg = Assert.prepEvalArg("Monochromatic")

local insert = table.insert
local floor = math.floor
local sort = table.sort

return function(color: Color3, value: number?)
	value = value or 3

	prepType("base", "Color3", color)
	prepType("swatches", "number", value)

	local v = floor(value)
	prepEvalArg("swatches", "be greater than 0", v > 0, v)

	local hsv, v2, v3 = color:ToHSV()
	local v4 = 1 / v

	local result = {}

	for _ = 1, v do
		insert(result, Color3.fromHSV(hsv, v2, v3))
		v3 = (v3 + v4) % 1
	end

	sort(result, function(p, p2): boolean
		return select(3, p:ToHSV()) < select(3, p2:ToHSV())
	end)

	return result
end