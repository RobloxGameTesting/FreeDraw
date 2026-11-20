local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local HoverEffect = require(ReplicatedStorage.client.ui.components.effect.HoverEffect)
local VotekickAvatar = require(script.Parent.VotekickAvatar)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function VotekickDetailsSource(props, props2)
	local state, setState = props2.useState(false)
	local hover = RoactFlipper.useSpring(props2, state and 1 or 0, v)
	local textSize, v2 = props2.useBinding(Vector2.new(0, 0))

	return createElement(Container, {
		size = Roact.joinBindings({ hover = hover, textSize = textSize }):map(function(p)
			return UDim2.fromOffset(Number.lerp(32, 40 + p.textSize.X + 12, p.hover), 32)
		end),
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = props.zIndex,
		clipsDescendants = true
	}, {
		Avatar = createElement(
			Container,
			{
				size = UDim2.fromOffset(32, 32),
				position = UDim2.fromScale(1, 0),
				anchorPoint = Vector2.new(1, 0)
			},
			{
				Image = createElement(Image, {
					image = ("rbxthumb://type=AvatarHeadShot&w=60&h=60&id=%d"):format(props.player.UserId),
					circular = true,
					size = UDim2.fromScale(1, 1)
				}),
				Border = createElement(Box, {
					color = colors.white,
					borderColor = colors.grey[300],
					circular = true,
					size = UDim2.fromScale(1, 1),
					zIndex = 0
				}),
				Padding = createElement("UIPadding", {
					PaddingTop = UDim.new(0, 1),
					PaddingBottom = UDim.new(0, 1),
					PaddingLeft = UDim.new(0, 1),
					PaddingRight = UDim.new(0, 1)
				})
			}
		),
		Text = createElement(Text, {
			text = Localization.String.new("votekick.details.startedBy", {
				player = ("@%s"):format(props.player.Name)
			}),
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 16,
			color = colors.grey[900],
			transparency = Binding.mapLerp(hover, 1, 0),
			position = UDim2.new(1, -40, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			zIndex = 10,
			[Roact.Change.AbsoluteSize] = props2.useCallback(function(p)
				v2(p.AbsoluteSize)
			end, {})
		}),
		Background = createElement(Box, {
			color = colors.grey[300],
			circular = true,
			transparency = Binding.mapLerp(hover, 1, 0),
			size = UDim2.fromScale(1, 1)
		}),
		HoverEffect = createElement(HoverEffect, { onHover = setState })
	})
end

local function VotekickDetails(p)
	local votekick = p.votekick

	return createElement(Container, { size = UDim2.new(1, 0, 0, 112), layoutOrder = p.layoutOrder }, {
		Source = createElement(VotekickDetailsSource, {
			player = votekick.source,
			position = UDim2.new(1, -16, 1, -16),
			anchorPoint = Vector2.new(1, 1),
			zIndex = 10
		}),
		Content = createElement(Container, { size = UDim2.fromScale(1, 1), clipsDescendants = true }, {
			Avatar = createElement(VotekickAvatar, {
				player = votekick.target,
				status = votekick.status,
				progress = votekick.progress,
				layoutOrder = 1
			}),
			Text = createElement(
				Container,
				{
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					layoutOrder = 2
				},
				{
					Label = createElement(Text, {
						text = Localization.String.new("votekick.details.label"),
						font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
						fontSize = 16,
						color = colors.grey[700],
						textYAlignment = Enum.TextYAlignment.Top,
						size = UDim2.new(0, 0, 0, 18),
						layoutOrder = 1
					}),
					Name = createElement(Container, {
						size = UDim2.new(1, 0, 0, 24),
						layoutOrder = 2
					}, {
						DisplayName = createElement(Text, {
							text = votekick.target.displayName,
							font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
							fontSize = 24,
							color = colors.brand,
							layoutOrder = 1
						}),
						Name = createElement(Text, {
							text = ("(@%s)"):format(votekick.target.name),
							font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
							fontSize = 16,
							color = colors.grey[500],
							textYAlignment = Enum.TextYAlignment.Top,
							size = UDim2.new(0, 0, 0, 18),
							layoutOrder = 2
						}),
						Layout = createElement("UIListLayout", {
							VerticalAlignment = Enum.VerticalAlignment.Bottom,
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 6)
						})
					}),
					Reason = createElement(Text, {
						text = Localization.String.new("votekick.details.reason", {
							reason = Localization.String.new(("votekick.reason.%s"):format(votekick.reason.value))
						}),
						font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
						fontSize = 20,
						color = colors.grey[900],
						layoutOrder = 3
					}),
					Layout = createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					})
				}
			),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16)
			}),
			Padding = createElement("UIPadding", { PaddingLeft = UDim.new(0, 16) })
		})
	})
end

VotekickDetailsSource = hook(VotekickDetailsSource, { componentType = "PureComponent" })
return (hook(VotekickDetails, { componentType = "PureComponent" }))