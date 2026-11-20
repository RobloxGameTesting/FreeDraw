local function createUseReducer(callback, callback2)
	return function(callback3, p)
		local v, v2 = callback2(p)
		return v, (callback(function(p2)
			v2(callback3(v, p2))
		end, { v }))
	end
end

return createUseReducer