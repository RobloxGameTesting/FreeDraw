local function createUseCallback(callback)
	return function(callback2, p)
		return callback(function()
			return callback2
		end, p)
	end
end

return createUseCallback