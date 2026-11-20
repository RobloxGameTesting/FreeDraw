local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Card = require(ReplicatedStorage.client.ui.components.template.Card)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local images = require(ReplicatedStorage.client.ui.assets.images)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local VotekickDetails = require(script.Parent.VotekickDetails)
local VotekickStatistics = require(script.Parent.VotekickStatistics)
local VotekickButtons = require(script.Parent.VotekickButtons)
local VotekickAvatar = require(script.Parent.VotekickAvatar)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local votekickSlice = require(script.Parent.votekickSlice)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 7, dampingRatio = 1 }
local v2 = { frequency = 5, dampingRatio = 1 }

local createElement = Roact.createElement

local function VotekickPreview(props)
	local votekick = props.votekick

	local v3 = { size = UDim2.new(1, 0, 0, 64), transparency = props.transparency }
	local v4 = {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Avatar = createElement(VotekickAvatar, {
				player = votekick.target,
				status = votekick.status,
				progress = votekick.progress,
				background = true,
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
						layoutOrder = 1
					}),
					DisplayName = createElement(Text, {
						text = votekick.target.DisplayName,
						font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
						fontSize = 24,
						color = colors.brand,
						layoutOrder = 2
					}),
					Layout = createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 8)
					})
				}
			),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16)
			}),
			Padding = createElement("UIPadding", { PaddingLeft = UDim.new(0, 20) })
		}),
		RippleEffect = createElement(RippleEffect, { color = colors.grey[600], zIndex = 0 }),
		HoverTintEffect = createElement(HoverTintEffect, { color = colors.grey[600], zIndex = 0 }),
		Button = 0
	}
	local button

	if props.active then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	v4.Button = button
	return createElement(CanvasContainer, v3, v4)
end

local function VotekickContent(props)
	local v3 = { size = UDim2.fromScale(1, 1), transparency = props.transparency }

	local v4 = {
		size = UDim2.fromOffset(48, 48),
		position = UDim2.fromScale(1, 0),
		anchorPoint = Vector2.new(1, 0)
	}
	local v5 = {
		Image = createElement(Image, {
			image = images.votekick.close,
			color = colors.black,
			transparency = 0.7,
			size = UDim2.fromOffset(10, 10),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Button = 0,
		CursorEffect = 0
	}
	local button

	if props.active then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClose })
	end

	v5.Button = button

	v5.CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
	return createElement(CanvasContainer, v3, {
		Close = createElement(Container, v4, v5),
		Content = createElement(Container, {
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			clipsDescendants = true,
			[Roact.Change.AbsoluteSize] = function(p)
				props.onSize(p.AbsoluteSize)
			end
		}, {
			Details = createElement(VotekickDetails, { votekick = props.votekick, layoutOrder = 1 }),
			Statistics = createElement(VotekickStatistics, {
				votekick = props.votekick,
				layoutOrder = 2
			}),
			Buttons = createElement(VotekickButtons, {
				votekick = props.votekick,
				layoutOrder = 3,
				onVote = props.onVote
			}),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})
	})
end

local function Votekick(props, p)
	local votekick = props.votekick
	local expanded = votekick and votekick.expanded or props.alwaysExpanded

	local v3 = RoactFlipper.useSpring(p, votekick and votekick.visible and 1 or 0, v)
	local v4 = RoactFlipper.useSpring(p, expanded and 1 or 0, v2)
	local size, onSize = p.useBinding(Vector2.new(0, 0))

	if votekick then
		return createElement(Card, {
			size = Roact.joinBindings({ size = size, expanded = v4 }):map(function(p2)
				return UDim2.new(props.size, UDim.new(0, Number.lerp(64, p2.size.Y, p2.expanded)))
			end),
			position = props.position,
			anchorPoint = props.anchorPoint,
			transparency = Binding.mapLerp(v3, 1, 0),
			visible = v3:map(function(p2): boolean
				return p2 > 0.025
			end)
		}, {
			Preview = createElement(VotekickPreview, {
				votekick = votekick,
				active = not expanded,
				onClick = props.onExpand,
				transparency = v4
			}),
			Content = createElement(VotekickContent, {
				votekick = votekick,
				active = expanded,
				onSize = onSize,
				onVote = props.onVote,
				onClose = props.onClose,
				transparency = Binding.mapLerp(v4, 1, 0)
			}),
			Button = createElement(Button)
		})
	end

	return nil
end

VotekickPreview = hook(VotekickPreview, { componentType = "PureComponent" })
VotekickContent = hook(VotekickContent, { componentType = "PureComponent" })
local v3 = hook(Votekick, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { votekick = p.votekick }
end, function(callback)
	return {
		onVote = function(p)
			callback(votekickSlice.thunks.setVotekickVoteAsync(p))
		end,
		onExpand = function()
			callback(votekickSlice.actions.expandVotekick())
		end,
		onClose = function()
			callback(votekickSlice.actions.closeVotekick())
		end
	}
end)(v3))