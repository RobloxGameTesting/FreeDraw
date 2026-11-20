local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local actionCreator = Rodux.makeActionCreator("options/thickness/setThickness", function(thickness)
	return { thickness = thickness }
end)

return {
	reducer = Rodux.createReducer(0.2, {
		[actionCreator.name] = function(_, p)
			return p.thickness
		end
	}),
	actions = { setThickness = actionCreator }
}