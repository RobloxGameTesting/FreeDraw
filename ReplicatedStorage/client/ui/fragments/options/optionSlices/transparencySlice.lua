local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local actionCreator = Rodux.makeActionCreator("options/transparency/setTransparency", function(transparency)
	return { transparency = transparency }
end)

return {
	reducer = Rodux.createReducer(0, {
		[actionCreator.name] = function(_, p)
			return p.transparency
		end
	}),
	actions = { setTransparency = actionCreator }
}