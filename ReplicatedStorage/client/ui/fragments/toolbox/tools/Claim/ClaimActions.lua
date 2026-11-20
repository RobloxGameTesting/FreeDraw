local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local ToolActions = require(script.Parent.Parent.Parent.ToolActions)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local claimSlice = require(script.Parent.claimSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement
local LocalPlayer = Players.LocalPlayer

local function ClaimActions(props, p)
	return createElement(ToolActions, {
		active = props.active,
		tool = ToolType.Claim,
		actions = p.useMemo(function()
			return {
				{
					id = "deleteClaim",
					text = Localization.String.new("toolbox.claim.actions.deleteClaim"),
					icon = "trash",
					active = props.canDelete,
					onClick = props.onDelete
				}
			}
		end, { props.onDelete, props.canDelete })
	})
end

local v = hook(ClaimActions, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		canDelete = p.claims[LocalPlayer.UserId] and true or false
	}
end, function(callback)
	return {
		onDelete = function()
			callback(claimSlice.thunks.deleteClaim())
		end
	}
end)(v))