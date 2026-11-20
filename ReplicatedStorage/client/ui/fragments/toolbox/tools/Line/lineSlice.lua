local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local actionCreator = Rodux.makeActionCreator("toolbox/line/createLine", function(id, position)
	return { id = id, position = position }
end)

local actionCreator2 = Rodux.makeActionCreator("toolbox/line/addPointToLine", function(id, position)
	return { id = id, position = position }
end)

local actionCreator3 = Rodux.makeActionCreator("toolbox/line/deleteLine", function(id)
	return { id = id }
end)

local actionCreator4 = Rodux.makeActionCreator("toolbox/line/clearLines", function()
	return {}
end)

return {
	reducer = Rodux.combineReducers({
		lines = Rodux.createReducer({}, {
			[actionCreator.name] = function(p, p2)
				return Sift.Dictionary.set(p, p2.id, { p2.position, p2.position })
			end,
			[actionCreator2.name] = function(p, p2)
				return Sift.Dictionary.update(p, p2.id, function(p3)
					return Sift.Dictionary.set(p3, 2, p2.position)
				end)
			end,
			[actionCreator3.name] = function(p, p2)
				return Sift.Dictionary.removeKey(p, p2.id)
			end,
			[actionCreator4.name] = function()
				return {}
			end
		})
	}),
	actions = {
		createLine = actionCreator,
		moveLine = actionCreator2,
		deleteLine = actionCreator3,
		clearLines = actionCreator4
	}
}