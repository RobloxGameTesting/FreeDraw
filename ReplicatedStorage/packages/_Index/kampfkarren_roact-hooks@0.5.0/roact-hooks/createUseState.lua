local v = {}

local function extractValue(callback, p) -- 1 equivalent call inferred from this helper
	if type(callback) == "function" then
		return callback(p)
	end

	return callback
end

local function createUseState(object)
	local v2 = {}

	return function(callback)
		object.hookCounter += 1
		local hookCounter = object.hookCounter
		local v3 = object.state[hookCounter]

		if v3 == nil then
			v3 = object.defaultStateValues[hookCounter]

			if v3 == v then
				v3 = nil
			elseif v3 == nil then
				if type(callback) == "function" then
					v3 = callback()

					if v3 == nil then
						object.defaultStateValues[hookCounter] = v
					else
						object.defaultStateValues[hookCounter] = v3
					end
				else
					object.defaultStateValues[hookCounter] = callback
					v3 = callback
				end
			end
		elseif v3 == v then
			v3 = nil
		end

		local v4 = v2[hookCounter]

		if v4 == nil then
			v4 = function(p)
				local v5 = object.state[hookCounter]

				if v5 == nil then
					v5 = object.defaultStateValues[hookCounter]
				end

				if v5 == v then
					v5 = nil
				end

				p = extractValue(p, v5) -- inferred equivalent call

				if p == nil then
					p = v
				end

				object:setState({ [hookCounter] = p })
			end

			v2[hookCounter] = v4
		end

		return v3, v4
	end
end

return createUseState