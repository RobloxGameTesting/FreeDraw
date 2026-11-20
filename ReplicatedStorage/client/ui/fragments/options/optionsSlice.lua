local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local colorSlice = require(script.Parent.optionSlices.colorSlice)
local thicknessSlice = require(script.Parent.optionSlices.thicknessSlice)
local transparencySlice = require(script.Parent.optionSlices.transparencySlice)

local actionCreator = Rodux.makeActionCreator("options/toggleManual", function(_)
	return {}
end)

return {
	reducer = Rodux.combineReducers({
		color = colorSlice.reducer,
		thickness = thicknessSlice.reducer,
		transparency = transparencySlice.reducer,
		manual = Rodux.createReducer(false, {
			[actionCreator.name] = function(p): boolean
				return not p
			end
		})
	}),
	actions = { toggleManual = actionCreator },
	selectors = {
		selectOptions = function(p)
			return {
				color = p.options.color.primary,
				thickness = p.options.thickness,
				transparency = p.options.transparency
			}
		end
	}
}