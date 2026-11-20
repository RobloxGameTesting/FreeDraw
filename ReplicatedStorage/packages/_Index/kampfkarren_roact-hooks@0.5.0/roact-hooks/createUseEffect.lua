local function createUseEffect(p)
	return function(callback, p2)
		assert(typeof(callback) == "function", "useEffect callback is not a function")

		p.hookCounter += 1
		local hookCounter = p.hookCounter

		p.effects[hookCounter] = { callback, p2 }
	end
end

return createUseEffect