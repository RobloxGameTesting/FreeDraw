local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local TextButton = require(ReplicatedStorage.client.ui.components.button.TextButton)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local config = require(ReplicatedStorage.shared.data.config)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local LocalPlayer = Players.LocalPlayer

local createElement = Roact.createElement

local function ProBuyButton(p, p2)
	local special = p.tier.special
	local style

	if special then
		style = ButtonStyle.Filled
	else
		style = ButtonStyle.Bordered
	end

	local v = {
		style = style,
		size = UDim2.new(0.5, -4, 0, 52),
		layoutOrder = p.index,
		onClick = p2.useCallback(function()
			MarketplaceService:PromptProductPurchase(LocalPlayer, p.tier.id)
		end, { p.tier.id })
	}

	local v2 = {
		text = `{p.tier.length}d`,
		color = 0,
		font = 0,
		fontSize = 24,
		position = 0,
		anchorPoint = 0
	}
	local color = if special then colors.white else colors.grey[900]
	v2.color = color
	v2.font = Font.new(fonts.BuilderMono, Enum.FontWeight.Regular)

	v2.position = UDim2.fromScale(0, 0.5)
	v2.anchorPoint = Vector2.new(0, 0.5)
	local children = { Length = createElement(Text, v2), Cost = 0, Padding = 0 }

	local v3 = { size = UDim2.fromScale(1, 1) }

	local v4 = {
		text = `{p.tier.cost}R$`,
		font = Font.new(fonts.BuilderMono, Enum.FontWeight.ExtraBold),
		fontSize = 18,
		color = 0,
		layoutOrder = 1
	}

	local color2 = if special then colors.white else colors.brand
	v4.color = color2
	local children2 = { Total = createElement(Text, v4), Day = 0, Layout = 0 }

	local v5 = {
		text = `{math.ceil(p.tier.cost / p.tier.length)}R$/day`,
		font = Font.new(fonts.BuilderMono, Enum.FontWeight.ExtraBold),
		fontSize = 15,
		color = 0,
		transparency = 0.5,
		layoutOrder = 2
	}

	local color3 = if special then colors.white else colors.brand
	v5.color = color3
	children2.Day = createElement(Text, v5)

	children2.Layout = createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2)
	})
	children.Cost = createElement(Container, v3, children2)

	children.Padding = createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 8)
	})
	return createElement(TextButton, v, children)
end

local function ProBuy(p)
	local children = {}

	for k, tier in config.pro.tiers do
		children[tier.length] = createElement(ProBuyButton, { tier = tier, index = k })
	end

	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = p.layoutOrder
		},
		{
			Label = createElement(Text, {
				text = Localization.String.new("pro.buy"),
				font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
				fontSize = 16,
				color = colors.grey[900],
				layoutOrder = 1
			}),
			Buttons = createElement(
				Container,
				{
					layoutOrder = 2,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y
				},
				Sift.Dictionary.join(children, {
					Layout = createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Wraps = true,
						Padding = UDim.new(0, 8)
					})
				})
			),
			Highlights = createElement(Container, { size = UDim2.new(1, 0, 0, 16), layoutOrder = 3 }, {
				MostPopular = createElement(Text, {
					text = Localization.String.new("pro.highlight.mostPopular"),
					font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
					fontSize = 16,
					color = colors.brand
				}),
				BestValue = createElement(Text, {
					text = Localization.String.new("pro.highlight.bestValue"),
					font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
					fontSize = 16,
					color = colors.brand,
					position = UDim2.fromScale(1, 0),
					anchorPoint = Vector2.new(1, 0)
				})
			}),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			})
		}
	)
end

ProBuyButton = hook(ProBuyButton, { componentType = "PureComponent" })
return (hook(ProBuy, { componentType = "PureComponent" }))