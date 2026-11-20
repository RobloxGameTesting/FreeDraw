local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local TopbarButton = require(script.Parent.Parent.TopbarButton)
local screenshotSlice = require(ReplicatedStorage.client.ui.fragments.screenshot.screenshotSlice)
local images = require(ReplicatedStorage.client.ui.assets.images)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function ScreenshotButton(props)
	local v = {
		name = "screenshot",
		caption = Localization.String.new("topbar.button.screenshot.caption"),
		image = 0,
		imageScale = 1,
		order = 0,
		alignment = "Right",
		toggle = false,
		onSelect = 0
	}
	local image

	if props.active then
		image = images.topbar.screenshot.active
	else
		image = images.topbar.screenshot.inactive
	end

	v.image = image

	v.order = props.order

	v.onSelect = props.onClick
	return createElement(TopbarButton, v)
end

local v = hook(ScreenshotButton, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { active = p.screenshot }
end, function(callback)
	return {
		onClick = function()
			callback(screenshotSlice.actions.toggleScreenshot())
		end
	}
end)(v))