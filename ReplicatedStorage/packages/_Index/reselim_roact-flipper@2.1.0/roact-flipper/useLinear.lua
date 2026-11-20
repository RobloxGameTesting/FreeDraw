local Flipper = require(script.Parent.Parent.Flipper)

local useGoal = require(script.Parent.useGoal)

local function useLinear(p, p2, p3)
	return useGoal(p, Flipper.Linear.new(p2, p3))
end

return useLinear