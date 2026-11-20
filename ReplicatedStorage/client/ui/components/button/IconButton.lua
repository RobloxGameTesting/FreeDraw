local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(script.Parent.Parent.base.Container)
local Button = require(script.Parent.Parent.base.Button)
local Box = require(script.Parent.Parent.base.Box)
local Icon = require(script.Parent.Parent.base.Icon)
local RippleEffect = require(script.Parent.Parent.effect.RippleEffect)
local CursorEffect = require(script.Parent.Parent.effect.CursorEffect)
local HoverEffect = require(script.Parent.Parent.effect.HoverEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function IconButton(props, p)
	local state, setState = p.useState(false)
	local v2 = RoactFlipper.useSpring(p, state and 1 or 0, v)

	local v3 = {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder
	}
	local join = Sift.Dictionary.join
	local v4 = props[Roact.Children]
	local v6 = {
		icon = props.icon,
		size = props.iconSize,
		color = 0,
		position = 0,
		anchorPoint = 0
	}
	local color

	if props.enabled then
		color = props.color
	else
		color = colors.grey[400]
	end

	v6.color = color

	v6.position = UDim2.fromScale(0.5, 0.5)
	v6.anchorPoint = Vector2.new(0.5, 0.5)
	local v5 = {
		Icon = createElement(Icon, v6),
		Button = 0,
		HoverEffect = 0,
		RippleEffect = 0,
		HoverBackground = 0
	}
	local button

	if props.enabled then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	v5.Button = button
	local hoverEffect

	if props.enabled then
		hoverEffect = createElement(HoverEffect, { onHover = setState })
	end

	v5.HoverEffect = hoverEffect
	local rippleEffect

	if props.enabled then
		rippleEffect = createElement(RippleEffect, {
			color = props.color,
			center = true,
			size = UDim2.fromOffset(props.iconSize * 1.6666666666666665, props.iconSize * 1.6666666666666665),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	v5.RippleEffect = rippleEffect
	local hoverBackground

	if props.enabled then
		hoverBackground = createElement(Box, {
			color = props.color,
			transparency = Binding.mapLerp(v2, 1, 0.9),
			circular = true,
			size = UDim2.fromOffset(props.iconSize * 1.6666666666666665, props.iconSize * 1.6666666666666665),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	v5.HoverBackground = hoverBackground
	return createElement(Container, v3, join(v4, v5))
end

return (hook(IconButton, {
	componentType = "PureComponent",
	defaultProps = { iconSize = 24, color = colors.black, enabled = true }
}))