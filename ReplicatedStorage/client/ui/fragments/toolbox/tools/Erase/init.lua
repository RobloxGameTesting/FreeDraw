local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

return {
	type = ToolType.Erase,
	icon = "erase",
	keys = { Enum.KeyCode.Three },
	slice = require(script.eraseSlice),
	controller = require(script.eraseController),
	cursor = require(script.eraseCursor),
	optionsComponent = require(script.EraseOptions)
}