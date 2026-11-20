local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local TopbarButton = require(script.Parent.Parent.TopbarButton)
local playerListSlice = require(ReplicatedStorage.client.ui.fragments.playerList.playerListSlice)
local images = require(ReplicatedStorage.client.ui.assets.images)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function PlayerListButton(props)
	local v = {
		name = "playerList",
		caption = Localization.String.new("topbar.button.playerList.caption"),
		image = 0,
		imageScale = 1,
		order = 0,
		alignment = "Right",
		toggle = false,
		onSelect = 0
	}
	local image

	if props.active then
		image = images.topbar.playerList.active
	else
		image = images.topbar.playerList.inactive
	end

	v.image = image

	v.order = props.order

	v.onSelect = props.onClick
	return createElement(TopbarButton, v)
end

local v = hook(PlayerListButton, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { active = p.playerList.open }
end, function(callback)
	return {
		onClick = function()
			callback(playerListSlice.actions.toggleOpen())
		end
	}
end)(v))