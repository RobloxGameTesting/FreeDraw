local Assert = require(script.Parent._Util.Assert)
local prepType = Assert.prepTypeOf("isLight")

local isDark = require(script.Parent.isDark)

return function(color: Color3): boolean
	prepType("colour", "Color3", color)

	return not isDark(color)
end