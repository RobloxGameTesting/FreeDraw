local dependenciesDifferent = require(script.Parent.dependenciesDifferent)

local function createUseMemo(callback)
	return function(callback2, dependencies)
		local v = callback(nil)
		local v2 = dependencies == nil

		if v.value == nil or dependenciesDifferent(dependencies, v.value.dependencies) or v2 then
			v.value = {
				dependencies = dependencies,
				memoizedValue = { callback2() }
			}
		end

		return unpack(v.value.memoizedValue)
	end
end

return createUseMemo