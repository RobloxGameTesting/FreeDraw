local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

return {
	type = ToolType.Draw,
	icon = "draw",
	keys = { Enum.KeyCode.One },
	slice = require(script.drawSlice),
	controller = require(script.drawController),
	renderer = require(script.drawRenderer),
	optionsComponent = require(script.DrawOptions)
}