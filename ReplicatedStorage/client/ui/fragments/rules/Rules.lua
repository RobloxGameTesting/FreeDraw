local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local TextButton = require(ReplicatedStorage.client.ui.components.button.TextButton)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { "contentSuitability", "griefing", "scribbling", "toxicity" }

local createElement = Roact.createElement

local function RulesHeader(p)
	return createElement(Container, { size = UDim2.new(1, 0, 0, 90), layoutOrder = p.layoutOrder }, {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Text = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
				Title = createElement(Text, {
					text = Localization.String.new("rules.title"),
					color = colors.grey[900],
					font = Font.new(fonts.BuilderExtended, Enum.FontWeight.ExtraBold),
					fontSize = 32,
					layoutOrder = 1
				}),
				Description = createElement(Text, {
					text = Localization.String.new("rules.description"),
					color = colors.grey[900],
					font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
					fontSize = 18,
					layoutOrder = 2
				}),
				Layout = createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6)
				})
			}),
			Icon = createElement(Icon, {
				icon = "checkboxMultiple",
				size = 48,
				color = colors.grey[400],
				position = UDim2.fromScale(1, 0.5),
				anchorPoint = Vector2.new(1, 0.5)
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			})
		}),
		Divider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			position = UDim2.fromScale(0, 1),
			anchorPoint = Vector2.new(0, 1)
		}),
		Background = createElement(Box, {
			color = colors.grey[100],
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		})
	})
end

local function RulesRule(p)
	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = p.layoutOrder
		},
		{
			Text = createElement(Text, {
				text = Localization.String.new(`rules.rule.{p.id}`),
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				fontSize = 20,
				lineHeight = 1.15,
				textXAlignment = Enum.TextXAlignment.Left,
				wrapped = true,
				rich = true,
				size = UDim2.fromScale(1, 0),
				automaticSize = Enum.AutomaticSize.Y
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
				PaddingTop = UDim.new(0, 14),
				PaddingBottom = UDim.new(0, 14)
			})
		}
	)
end

local function Rules(p)
	local children = {}
	local children2 = {}

	for k, id in v do
		children[id] = createElement(RulesRule, {
			id = id,
			layoutOrder = k * 2 - 1
		})

		if k < #v then
			children2[`Divider({id})`] = createElement(Box, {
				color = colors.grey[300],
				size = UDim2.new(1, -20, 0, 1),
				layoutOrder = k * 2
			}, {
				Gradient = createElement("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.1, 0),
						NumberSequenceKeypoint.new(0.9, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			})
		end
	end

	local size

	if p.width then
		size = UDim2.fromOffset(p.width, 0)
	else
		size = UDim2.fromScale(1, 0)
	end

	return createElement(Container, { size = size, automaticSize = Enum.AutomaticSize.Y }, {
		Header = createElement(RulesHeader, { layoutOrder = 1 }),
		Content = createElement(
			Container,
			{ size = UDim2.fromScale(1, 0), automaticSize = Enum.AutomaticSize.Y, layoutOrder = 2 },
			{
				Rules = createElement(
					Container,
					{
						size = UDim2.fromScale(1, 0),
						automaticSize = Enum.AutomaticSize.Y,
						layoutOrder = 1
					},
					{
						Content = createElement(
							Container,
							{ size = UDim2.fromScale(1, 1) },
							Sift.Dictionary.join(children, children2, {
								Layout = createElement("UIListLayout", {
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder
								})
							})
						),
						Border = createElement(Box, {
							radius = 4,
							borderColor = colors.grey[300],
							transparency = 1,
							size = UDim2.fromScale(1, 1)
						})
					}
				),
				Confirm = createElement(TextButton, {
					text = Localization.String.new("rules.button.confirm"),
					style = ButtonStyle.Bordered,
					layoutOrder = 3,
					onClick = p.onConfirm
				}),
				Layout = createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 20)
				}),
				Padding = createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24),
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 24)
				})
			}
		),
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	})
end

RulesHeader = hook(RulesHeader, { componentType = "PureComponent" })
RulesRule = hook(RulesRule, { componentType = "PureComponent" })
local v2 = hook(Rules, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onConfirm = function()
			callback(screensSlice.actions.popScreen())
		end
	}
end)(v2))