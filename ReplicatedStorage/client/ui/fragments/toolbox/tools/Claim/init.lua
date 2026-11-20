local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

return {
	type = ToolType.Claim,
	icon = "flag",
	keys = { Enum.KeyCode.Four },
	slice = require(script.claimSlice),
	controller = require(script.claimController),
	renderer = require(script.claimRenderer),
	actionsComponent = require(script.ClaimActions)
}