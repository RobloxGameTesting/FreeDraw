local Flipper = require(script.Parent.Parent.Flipper)

local useGoal = require(script.Parent.useGoal)

local function useSpring(p, p2, p3)
	return useGoal(p, Flipper.Spring.new(p2, p3))
end

return useSpring