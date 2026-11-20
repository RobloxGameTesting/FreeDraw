local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local claimsSlice = require(ReplicatedStorage.client.ui.fragments.claims.claimsSlice)

local actionCreator = Rodux.makeActionCreator("toolbox/claim/setClaim", function(position, rotation, size)
	return { position = position, rotation = rotation, size = size }
end)

local actionCreator2 = Rodux.makeActionCreator("toolbox/claim/clearClaim", function()
	return {}
end)

return {
	reducer = Rodux.createReducer(nil, {
		[actionCreator.name] = function(_, data)
			return { position = data.position, rotation = data.rotation, size = data.size }
		end,
		[actionCreator2.name] = function(): nil
			return nil
		end
	}),
	actions = { setClaim = actionCreator, clearClaim = actionCreator2 },
	thunks = {
		finishClaim = function()
			return function(object)
				local tool = object:getState().toolbox.tools[ToolType.Claim]

				if tool then
					object:dispatch(claimsSlice.thunks.setClaimAsync(tool))
					object:dispatch(actionCreator2())
				end
			end
		end,
		deleteClaim = function()
			return function(object)
				object:dispatch(claimsSlice.thunks.deleteClaimAsync())
			end
		end
	}
}