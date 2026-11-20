local function tracebackReporter(p)
	return debug.traceback(p)
end

local function thunkMiddleware(callback, object)
	return function(callback2)
		if typeof(callback2) ~= "function" then
			return callback(callback2)
		end

		local success, result = xpcall(function()
			return callback2(object)
		end, tracebackReporter)

		if success then
			return result
		end

		object._errorReporter.reportReducerError(object:getState(), callback2, {
			message = "Caught error in thunk",
			thrownValue = result
		})

		return nil
	end
end

return thunkMiddleware