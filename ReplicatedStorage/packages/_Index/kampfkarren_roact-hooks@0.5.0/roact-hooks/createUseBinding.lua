local function createUseBinding(p, callback)
	return function(p2)
		return unpack(callback({ p.createBinding(p2) }).value)
	end
end

return createUseBinding