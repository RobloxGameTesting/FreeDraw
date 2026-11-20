local useMotor = require(script.Parent.useMotor)
local getBinding = require(script.Parent.getBinding)
local function getInitialValue(p)
	if p.step then
		return p._targetValue
	end

	local result = {}

	for k, v in pairs(p) do
		result[k] = getInitialValue(v)
	end

	return result
end

local function useGoal(p, p2)
	local v = useMotor(p, (getInitialValue(p2)))
	v:setGoal(p2)
	return getBinding(v), v
end

return useGoal