local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local actionCreator = Rodux.makeActionCreator("screenshot/setScreenshot", function(active)
	return { active = active }
end)

local actionCreator2 = Rodux.makeActionCreator("screenshot/toggleScreenshot", function()
	return {}
end)

return {
	reducer = Rodux.createReducer(false, {
		[actionCreator.name] = function(_, p)
			return p.active
		end,
		[actionCreator2.name] = function(p): boolean
			return not p
		end
	}),
	actions = { setScreenshot = actionCreator, toggleScreenshot = actionCreator2 }
}