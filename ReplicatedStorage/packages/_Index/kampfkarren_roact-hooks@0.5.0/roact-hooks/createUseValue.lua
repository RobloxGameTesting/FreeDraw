local function createUseValue(state)
	return function(p)
		state.hookCounter += 1
		local hookCounter = state.hookCounter

		if state.values == nil then
			state.values = {}
		end

		if state.values[hookCounter] == nil then
			state.values[hookCounter] = { value = p }
		end

		return state.values[hookCounter]
	end
end

return createUseValue