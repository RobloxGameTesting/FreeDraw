local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local createElement = Roact.createElement

local function TextButton(props, p)
	local style = props.style

	local v, v2 = p.useBinding(Vector2.new(0, 0))
	local v3

	if style == ButtonStyle.Filled then
		v3 = props.color
	else
		v3 = colors.grey[300]
	end

	local color

	if style == ButtonStyle.Filled then
		color = colors.white
	else
		color = colors.grey[900]
	end

	if not props.enabled then
		local _ = colors.grey[100]
		color = colors.grey[400]
	end

	local v4 = {
		color = v3,
		radius = 8,
		borderColor = 0,
		transparency = 0,
		size = 0,
		position = 0,
		anchorPoint = 0,
		layoutOrder = 0
	}

	if style ~= ButtonStyle.Bordered then
		v3 = nil
	end

	v4.borderColor = v3
	v4.transparency = style ~= ButtonStyle.Filled and 1 or nil

	v4.size = props.size or v:map(function(p2)
		return UDim2.fromOffset(p2.X, 36)
	end)

	v4.position = props.position
	v4.anchorPoint = props.anchorPoint

	v4.layoutOrder = props.layoutOrder
	local size

	if props.size then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.fromScale(0, 1)
	end

	local automaticSize

	if props.size then
		automaticSize = Enum.AutomaticSize.None
	else
		automaticSize = Enum.AutomaticSize.X
	end

	local v5 = {
		size = size,
		automaticSize = automaticSize,
		[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
			v2(p2.AbsoluteSize)
		end, {})
	}
	local children = props[Roact.Children]

	if not children then
		children = { Text = 0, Padding = 0 }
		local v6 = {
			text = props.text,
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 18,
			color = color,
			position = 0,
			anchorPoint = 0
		}
		local position

		if props.size then
			position = UDim2.fromScale(0.5, 0.5)
		else
			position = UDim2.fromScale(0, 0.5)
		end

		v6.position = position
		local anchorPoint

		if props.size then
			anchorPoint = Vector2.new(0.5, 0.5)
		else
			anchorPoint = Vector2.new(0, 0.5)
		end

		v6.anchorPoint = anchorPoint
		children.Text = createElement(Text, v6)

		children.Padding = createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 18),
			PaddingRight = UDim.new(0, 18)
		})
	end

	local v6 = {
		TextContainer = createElement(Container, v5, children),
		Button = 0,
		HoverTintEffect = 0,
		RippleEffect = 0
	}
	local button

	if props.enabled then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	v6.Button = button
	local hoverTintEffect

	if props.enabled then
		hoverTintEffect = createElement(HoverTintEffect, { radius = 8, color = colors.black })
	end

	v6.HoverTintEffect = hoverTintEffect
	local rippleEffect

	if props.enabled then
		rippleEffect = createElement(RippleEffect, { radius = 8, color = color })
	end

	v6.RippleEffect = rippleEffect
	return createElement(Box, v4, v6)
end

return (hook(TextButton, {
	componentType = "PureComponent",
	defaultProps = {
		text = "Button",
		style = ButtonStyle.Filled,
		color = colors.brand,
		enabled = true
	}
}))