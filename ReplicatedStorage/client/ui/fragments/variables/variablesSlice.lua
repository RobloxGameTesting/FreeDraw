local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local variables = require(ReplicatedStorage.shared.data.variables)

local actionCreator = Rodux.makeActionCreator("variable/set", function(p, p2)
	return { key = p, value = p2 }
end)

local actionCreator2 = Rodux.makeActionCreator("variable/sync", function(p)
	return { data = p }
end)

return {
	reducer = Rodux.createReducer({}, {
		[actionCreator.name] = function(p, p2)
			return Sift.Dictionary.set(p, p2.key, p2.value)
		end,
		[actionCreator2.name] = function(_, p)
			return p.data
		end
	}),
	actions = { set = actionCreator, sync = actionCreator2 },
	selectors = {
		selectVariable = function(p, p2)
			local variable = p.variables[p2]

			if variable == nil then
				return variables[p2]
			end

			return variable
		end
	}
}