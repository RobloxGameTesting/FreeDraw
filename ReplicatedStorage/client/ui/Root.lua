local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local Desktop = require(script.Parent.platforms.Desktop)
local Phone = require(script.Parent.platforms.Phone)
local PlatformType = require(ReplicatedStorage.shared.enum.PlatformType)
local hook = require(ReplicatedStorage.shared.util.hook)
local screensSlice = require(script.Parent.fragments.screens.screensSlice)
local CoreGui = require(ReplicatedStorage.client.ui.components.CoreGui)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function Root(props)
	local platform = nil
	local v = { screen = props.screen, screenshot = props.screenshot, onClose = props.onClose }

	if props.platformType == PlatformType.Desktop then
		platform = createElement(Desktop, v)
	elseif props.platformType == PlatformType.Phone then
		platform = createElement(Phone, v)
	else
		error("Unknown platform type")
	end

	return createElement(Localization.localContext.component, nil, {
		Platform = platform,
		CoreGui = createElement(CoreGui, {
			[Enum.CoreGuiType.PlayerList] = false,
			[Enum.CoreGuiType.Backpack] = false
		})
	})
end

local v = hook(Root)

return (RoactRodux.connect(function(data)
	return {
		platformType = data.platform.type,
		locale = data.locale,
		screen = screensSlice.selectors.selectCurrentScreen(data),
		screenshot = data.screenshot
	}
end, function(callback)
	return {
		onClose = function()
			callback(screensSlice.actions.popScreen())
		end
	}
end)(v))