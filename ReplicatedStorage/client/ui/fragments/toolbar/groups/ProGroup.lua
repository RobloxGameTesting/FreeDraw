local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local ButtonType = require(ReplicatedStorage.shared.enum.ButtonType)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local ToolbarGroup = require(script.Parent.Parent.ToolbarGroup)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)

local LocalPlayer = Players.LocalPlayer

local createElement = Roact.createElement

local function ProGroup(props)
	local color

	if props.pro then
		color = colors.brand
	end

	local v = {
		id = "pro",
		name = Localization.String.new("toolbar.tooltip.pro"),
		type = ButtonType.Icon,
		icon = "pro",
		color = 0,
		onClick = 0
	}
	local color2

	if props.pro then
		color2 = colors.white
	end

	v.color = color2
	v.onClick = props.onNavigatePro
	return createElement(ToolbarGroup, {
		color = color,
		buttons = { v },
		layoutOrder = props.layoutOrder
	})
end

local v = hook(ProGroup, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		pro = p.players[LocalPlayer.UserId].proExpiry > os.time()
	}
end, function(callback)
	return {
		onNavigatePro = function()
			callback(screensSlice.actions.pushScreen("pro"))
		end
	}
end)(v))