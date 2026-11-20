local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local actionCreator = Rodux.makeActionCreator("toolbox/selectPanel", function(panel)
	return { panel = panel }
end)

return {
	reducer = Rodux.combineReducers({
		selectedPanel = Rodux.createReducer(nil, {
			[actionCreator.name] = function(p, p2)
				return if p ~= p2.panel then p2.panel else nil
			end
		})
	}),
	actions = { selectPanel = actionCreator }
}