local Assert = require(script.Parent.Parent._Util.Assert)
local isNaN = require(script.Parent.Parent._Util.isNaN)

local LAB = require(script.Parent.Parent.LAB)
local Constants = require(script.Parent.Constants)

local sin = math.sin
local cos = math.cos

local function LCHtoLAB(state)
	if isNaN(state.H) then
		state.H = 0
	end

	state.H *= Constants.DEG_RAD

	return {
		L = state.L,
		A = cos(state.H) * state.C,
		B = sin(state.H) * state.C
	}
end

local function FromLCH(data)
	Assert.typeOf("FromLCH", "lch", "table", data)

	Assert.typeOf("FromLCH", "lch.L", "number", data.L)
	Assert.typeOf("FromLCH", "lch.C", "number", data.C)
	Assert.typeOf("FromLCH", "lch.H", "number", data.H)

	local lCHtoLAB = LCHtoLAB(data)
	return LAB.fromLAB(lCHtoLAB)
end

return FromLCH