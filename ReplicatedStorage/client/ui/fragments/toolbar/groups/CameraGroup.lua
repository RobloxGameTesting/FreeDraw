local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local ButtonType = require(ReplicatedStorage.shared.enum.ButtonType)
local ToolbarGroup = require(script.Parent.Parent.ToolbarGroup)
local cameraSlice = require(ReplicatedStorage.client.ui.fragments.camera.cameraSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function CameraGroup(props)
	return createElement(ToolbarGroup, {
		buttons = {
			{
				id = "flip",
				name = Localization.String.new("toolbar.tooltip.flip"),
				type = ButtonType.Icon,
				icon = "flipHorizontal",
				onClick = props.onFlip
			},
			{
				id = "exit",
				name = Localization.String.new("toolbar.tooltip.exit"),
				type = ButtonType.Icon,
				icon = "close",
				onClick = props.onExit
			}
		},
		layoutOrder = props.layoutOrder
	})
end

local v = hook(CameraGroup, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onFlip = function()
			callback(cameraSlice.actions.flip())
		end,
		onExit = function()
			callback(cameraSlice.actions.setEnabled(false))
		end
	}
end)(v))