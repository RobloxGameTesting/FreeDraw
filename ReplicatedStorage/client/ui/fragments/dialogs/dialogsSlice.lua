local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

return {
	actions = {
		interact = Rodux.makeActionCreator("dialogs/interact", function(id, buttonId, context, state)
			return { id = id, buttonId = buttonId, context = context, state = state }
		end)
	}
}