local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = {
	{
		id = "shapeTool",
		icon = "shape",
		text = Localization.String.new("pro.reward.shapeTool")
	},
	{
		id = "rateLimit",
		icon = "clock",
		text = Localization.String.new("pro.reward.rateLimit")
	},
	{
		id = "claimSize",
		icon = "flag",
		text = Localization.String.new("pro.reward.claimSize")
	},
	{
		id = "smootherLines",
		icon = "gesture",
		text = Localization.String.new("pro.reward.smootherLines")
	},
	{
		id = "undoHistory",
		icon = "undoBold",
		text = Localization.String.new("pro.reward.undoHistory")
	},
	{
		id = "votekickPower",
		icon = "gavel",
		text = Localization.String.new("pro.reward.votekickPower")
	}
}

local createElement = Roact.createElement

local function ProFeature(props)
	return createElement(Container, {
		size = UDim2.new(1, 0, 0, 24),
		layoutOrder = props.layoutOrder
	}, {
		Icon = createElement(Icon, {
			icon = props.icon,
			color = colors.brand,
			size = 24,
			layoutOrder = 1
		}),
		Text = createElement(Text, {
			text = props.text,
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 20,
			color = colors.grey[900],
			layoutOrder = 2
		}),
		Layout = createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		})
	})
end

local function ProFeatures(p)
	local children = {}

	for k, v2 in v do
		children[v2.id] = createElement(ProFeature, {
			icon = v2.icon,
			text = v2.text,
			layoutOrder = k
		})
	end

	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = p.layoutOrder
		},
		Sift.Dictionary.join(children, {
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			})
		})
	)
end

ProFeature = hook(ProFeature, { componentType = "PureComponent" })
return (hook(ProFeatures, { componentType = "PureComponent" }))