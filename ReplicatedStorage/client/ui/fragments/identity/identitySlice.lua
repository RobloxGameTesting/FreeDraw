local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local IdentityType = require(ReplicatedStorage.shared.enum.IdentityType)

local actionCreator = Rodux.makeActionCreator("identity/setIdentity", function(identityType, identityPlayer)
	return { identityType = identityType, identityPlayer = identityPlayer }
end)

local actionCreator2 = Rodux.makeActionCreator("identity/removeIdentity", function()
	return {}
end)

return {
	reducer = Rodux.createReducer({
		type = IdentityType.Drawing,
		player = Players.LocalPlayer,
		active = false
	}, {
		[actionCreator.name] = function(_, p)
			return { type = p.identityType, player = p.identityPlayer, active = true }
		end,
		[actionCreator2.name] = function(p)
			return Sift.Dictionary.set(p, "active", false)
		end
	}),
	actions = { setIdentity = actionCreator, removeIdentity = actionCreator2 }
}