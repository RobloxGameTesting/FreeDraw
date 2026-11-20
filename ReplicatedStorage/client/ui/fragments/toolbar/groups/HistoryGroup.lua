local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local ButtonType = require(ReplicatedStorage.shared.enum.ButtonType)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local ToolbarGroup = require(script.Parent.Parent.ToolbarGroup)
local toolbarSlice = require(script.Parent.Parent.toolbarSlice)

local createElement = Roact.createElement

local function HistoryGroup(props)
	return createElement(ToolbarGroup, {
		buttons = {
			{
				id = "undo",
				name = Localization.String.new("toolbar.tooltip.undo"),
				type = ButtonType.Icon,
				icon = "undo",
				keys = { Enum.KeyCode.Z },
				onClick = props.onUndo
			},
			{
				id = "redo",
				name = Localization.String.new("toolbar.tooltip.redo"),
				type = ButtonType.Icon,
				icon = "redo",
				keys = { Enum.KeyCode.Y },
				onClick = props.onRedo
			}
		},
		layoutOrder = props.layoutOrder
	})
end

local v = hook(HistoryGroup, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onUndo = function()
			callback(toolbarSlice.thunks.undo())
		end,
		onRedo = function()
			callback(toolbarSlice.thunks.redo())
		end
	}
end)(v))