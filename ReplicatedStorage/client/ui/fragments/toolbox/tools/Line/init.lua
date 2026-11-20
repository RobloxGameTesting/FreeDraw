local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

return {
	type = ToolType.Line,
	icon = "line",
	keys = { Enum.KeyCode.Two },
	slice = require(script.lineSlice),
	controller = require(script.lineController),
	renderer = require(script.lineRenderer)
}