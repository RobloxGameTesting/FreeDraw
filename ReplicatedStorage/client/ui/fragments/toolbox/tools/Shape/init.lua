local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

return {
	type = ToolType.Shape,
	icon = "shape",
	keys = { Enum.KeyCode.Five },
	pro = true,
	slice = require(script.shapeSlice),
	controller = require(script.shapeController),
	renderer = require(script.shapeRenderer),
	optionsComponent = require(script.ShapeOptions)
}