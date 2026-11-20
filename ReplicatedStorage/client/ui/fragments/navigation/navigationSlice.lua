local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local actionCreator = Rodux.makeActionCreator("navigation/setOpen", function(open)
	return { open = open }
end)

local actionCreator2 = Rodux.makeActionCreator("navigation/toggleOpen", function()
	return {}
end)

return {
	reducer = Rodux.combineReducers({
		open = Rodux.createReducer(false, {
			[actionCreator.name] = function(_, p)
				return p.open
			end,
			[actionCreator2.name] = function(p): boolean
				return not p
			end
		})
	}),
	actions = { setOpen = actionCreator, toggleOpen = actionCreator2 }
}