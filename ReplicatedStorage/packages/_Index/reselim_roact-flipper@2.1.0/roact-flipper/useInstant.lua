local Flipper = require(script.Parent.Parent.Flipper)

local useGoal = require(script.Parent.useGoal)

local function useInstant(p, p2)
	return useGoal(p, Flipper.Instant.new(p2))
end

return useInstant