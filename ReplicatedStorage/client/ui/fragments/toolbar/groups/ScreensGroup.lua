local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local ButtonType = require(ReplicatedStorage.shared.enum.ButtonType)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local ToolbarGroup = require(script.Parent.Parent.ToolbarGroup)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local cameraSlice = require(ReplicatedStorage.client.ui.fragments.camera.cameraSlice)
local ContentStatus = require(ReplicatedStorage.shared.enum.ContentStatus)

local createElement = Roact.createElement

local function ScreensGroup(props, p)
	return createElement(ToolbarGroup, {
		buttons = {
			{
				id = "saveFiles",
				name = Localization.String.new("toolbar.tooltip.saveFiles"),
				type = ButtonType.Icon,
				enabled = props.dataReady,
				icon = "save",
				onClick = p.useCallback(function()
					props.onNavigateScreen("saveFiles")
				end, { props.onNavigateScreen })
			},
			{
				id = "settings",
				name = Localization.String.new("toolbar.tooltip.settings"),
				type = ButtonType.Icon,
				enabled = props.dataReady,
				icon = "cog",
				onClick = p.useCallback(function()
					props.onNavigateScreen("settings")
				end, { props.onNavigateScreen })
			},
			{
				id = "rules",
				name = Localization.String.new("toolbar.tooltip.rules"),
				type = ButtonType.Icon,
				icon = "list",
				onClick = p.useCallback(function()
					props.onNavigateScreen("rules")
				end, { props.onNavigateScreen })
			},
			{
				id = "topDownCamera",
				name = Localization.String.new("toolbar.tooltip.topDownCamera"),
				type = ButtonType.Icon,
				icon = "camera",
				onClick = props.onNavigateCamera
			}
		},
		layoutOrder = props.layoutOrder
	})
end

local v = hook(ScreensGroup, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		dataReady = p.userData.status == ContentStatus.Loaded
	}
end, function(callback)
	return {
		onNavigateScreen = function(p)
			callback(screensSlice.actions.pushScreen(p))
		end,
		onNavigateCamera = function()
			callback(cameraSlice.actions.toggleEnabled())
		end
	}
end)(v))