local function createUseContext(p, callback, callback2)
	local object = setmetatable({}, { __index = p })

	return function(p2)
		p2.Consumer.init(object)

		local contextEntry = object.contextEntry
		local v

		if contextEntry ~= nil then
			v = contextEntry.value
		end

		local v2, v3 = callback2(v)

		callback(function()
			if contextEntry == nil then
				return
			end

			if v2 ~= contextEntry.value then
				v3(contextEntry.value)
			end

			return contextEntry.onUpdate:subscribe(v3)
		end, { contextEntry })

		return v2
	end
end

return createUseContext