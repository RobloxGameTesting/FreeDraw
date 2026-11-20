local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local actionCreator = Rodux.makeActionCreator("toolbox/erase/setOptions", function(p)
	return p
end)

return {
	reducer = Rodux.combineReducers({
		options = Rodux.createReducer({ radius = 1 }, {
			[actionCreator.name] = function(p, p2)
				return Sift.Dictionary.join(p, { radius = p2.radius })
			end
		})
	}),
	actions = { setOptions = actionCreator }
}