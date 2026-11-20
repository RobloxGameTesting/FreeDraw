local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

return {
	type = ToolType.Eyedropper,
	icon = "eyedropper",
	ephemeral = true,
	controller = require(script.eyedropperController)
}