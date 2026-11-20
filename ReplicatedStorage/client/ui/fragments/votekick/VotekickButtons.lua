local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local VotekickVote = require(ReplicatedStorage.shared.enum.VotekickVote)
local VotekickStatus = require(ReplicatedStorage.shared.enum.VotekickStatus)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 7, dampingRatio = 1 }
local v2 = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function VotekickVoteButton(props, p)
	local v3 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)
	local v4 = RoactFlipper.useSpring(p, props.enabled and 1 or 0, v2)
	local mapLerp = Binding.mapLerp(v3, props.color, colors.white)

	local v5 = { size = props.size, position = props.position, anchorPoint = props.anchorPoint }
	local v6 = {
		Text = createElement(Text, {
			text = props.text,
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 18,
			color = mapLerp,
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		RippleEffect = 0,
		BackgroundContainer = 0,
		Button = 0
	}
	local rippleEffect

	if props.enabled then
		rippleEffect = createElement(RippleEffect, { color = mapLerp })
	end

	v6.RippleEffect = rippleEffect

	local v7 = { size = UDim2.fromScale(1, 1), clipsDescendants = true, zIndex = 0 }

	local v8 = { size = UDim2.new(1, 12, 1, 12), position = 0, anchorPoint = 0 }
	local position

	if props.flip then
		position = UDim2.fromScale(1, 1)
	else
		position = UDim2.fromScale(0, 1)
	end

	v8.position = position
	local anchorPoint

	if props.flip then
		anchorPoint = Vector2.new(1, 1)
	else
		anchorPoint = Vector2.new(0, 1)
	end

	v8.anchorPoint = anchorPoint
	local hoverTintEffect

	if props.enabled then
		hoverTintEffect = createElement(HoverTintEffect, { radius = 12, color = mapLerp })
	end

	v6.BackgroundContainer = createElement(Container, v7, {
		BackgroundInnerContainer = createElement(Container, v8, {
			HoverTintEffect = hoverTintEffect,
			Background = createElement(Box, {
				color = Binding.mapLerp(v4, colors.grey[400], props.color),
				radius = 12,
				transparency = Binding.mapLerp(v3, 1, 0),
				size = UDim2.fromScale(1, 1),
				zIndex = 0
			})
		})
	})
	local button

	if props.enabled then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	v6.Button = button
	return createElement(Container, v5, v6)
end

local function VotekickButtons(props, p)
	local votekick = props.votekick

	return createElement(Container, {
		size = UDim2.new(1, 0, 0, 40),
		layoutOrder = props.layoutOrder
	}, {
		DontKick = createElement(VotekickVoteButton, {
			text = Localization.String.new("votekick.button.dontKick"),
			active = props.votekick.vote == VotekickVote.DontKick,
			color = colors.red[900],
			enabled = votekick.status == VotekickStatus.Pending,
			size = UDim2.fromScale(0.5, 1),
			onClick = p.useCallback(function()
				props.onVote(VotekickVote.DontKick)
			end, { props.onVote })
		}),
		Divider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(0, 1, 1, 0),
			position = UDim2.fromScale(0.5, 0),
			zIndex = 10
		}),
		Kick = createElement(VotekickVoteButton, {
			text = Localization.String.new("votekick.button.kick"),
			active = props.votekick.vote == VotekickVote.Kick,
			color = colors.green[900],
			enabled = votekick.status == VotekickStatus.Pending,
			flip = true,
			size = UDim2.fromScale(0.5, 1),
			position = UDim2.fromScale(1, 0),
			anchorPoint = Vector2.new(1, 0),
			onClick = p.useCallback(function()
				props.onVote(VotekickVote.Kick)
			end, { props.onVote })
		})
	})
end

VotekickVoteButton = hook(VotekickVoteButton, { componentType = "PureComponent" })
return (hook(VotekickButtons, { componentType = "PureComponent" }))