local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local TopbarButton = require(script.Parent.Parent.TopbarButton)
local images = require(ReplicatedStorage.client.ui.assets.images)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local CmdrClient = require((ReplicatedStorage:WaitForChild("CmdrClient")))

local createElement = Roact.createElement

local function CmdrButton(p)
	return createElement(TopbarButton, {
		name = "cmdr",
		caption = Localization.String.new("topbar.button.cmdr.caption"),
		image = images.topbar.cmdr,
		imageScale = 1,
		order = p.order,
		alignment = "Right",
		toggle = false,
		onSelect = function()
			CmdrClient:Show()
		end
	})
end

return (hook(CmdrButton, { componentType = "PureComponent" }))