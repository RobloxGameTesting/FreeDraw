local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local function createComponentPropertyForwarder(p)
	return function(items, items2)
		local result = {}

		for k, item in items do
			if typeof(k) == "string" then
				local v = p[k]

				if v then
					result[v] = item
				end
			elseif k ~= Roact.Children then
				result[k] = item
			end
		end

		if items2 then
			for k, item in items2 do
				result[k] = item
			end
		end

		return result
	end
end

return createComponentPropertyForwarder