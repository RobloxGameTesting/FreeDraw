local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Blend = require(ReplicatedStorage.shared.lib.Blend)

local createElement = Roact.createElement

local v = { frequency = 7, dampingRatio = 1 }

local function ToolAction(props, p)
	local v2 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)
	local v3, v4 = p.useBinding(Vector2.new(0, 0))

	local mapLerp = Binding.mapLerp(v2, colors.grey[300], colors.brand)
	local mapLerp2 = Binding.mapLerp(v2, colors.grey[900], colors.white)

	local v5 = {
		size = v3:map(function(p2)
			return UDim2.new(0, p2.X, 1, 0)
		end)
	}

	local v6 = {
		size = UDim2.fromScale(0, 1),
		automaticSize = Enum.AutomaticSize.X,
		[Roact.Change.AbsoluteSize] = function(p2)
			v4(p2.AbsoluteSize)
		end
	}
	local children2 = {
		Icon = createElement(Icon, {
			icon = props.icon,
			size = 24,
			color = mapLerp2,
			layoutOrder = 1
		}),
		Text = 0,
		Layout = 0,
		Padding = 0
	}
	local text

	if props.text then
		text = createElement(Text, {
			text = props.text,
			font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
			fontSize = 18,
			color = mapLerp2,
			layoutOrder = 2
		})
	end

	children2.Text = text

	children2.Layout = createElement("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 12)
	})
	local paddingLeft

	if props.text then
		paddingLeft = UDim.new(0, 18)
	else
		paddingLeft = UDim.new(0, 12)
	end

	local paddingRight

	if props.text then
		paddingRight = UDim.new(0, 18)
	else
		paddingRight = UDim.new(0, 12)
	end

	children2.Padding = createElement("UIPadding", {
		PaddingLeft = paddingLeft,
		PaddingRight = paddingRight
	})
	local children = {
		Content = createElement(Container, v6, children2),
		Background = createElement(Box, {
			color = mapLerp,
			circular = true,
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		}),
		HoverTintEffect = 0,
		RippleEffect = 0,
		Button = 0
	}
	local hoverTintEffect

	if props.active then
		hoverTintEffect = createElement(HoverTintEffect, { circular = true, color = colors.white })
	end

	children.HoverTintEffect = hoverTintEffect
	local rippleEffect

	if props.active then
		rippleEffect = createElement(RippleEffect, {
			color = colors.white,
			center = not props.text
		})
	end

	children.RippleEffect = rippleEffect
	local button

	if props.active then
		button = createElement(Button, {
			[Roact.Event.Activated] = p.useCallback(function()
				props.onClick(props.id)
			end, { props.onClick, props.id })
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	children.Button = button
	return createElement(Container, v5, children)
end

local function ToolActions(props, p)
	local v2 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)

	local children = {}

	for _, action in props.actions do
		children[("Action(%s)"):format(action.id)] = createElement(ToolAction, {
			id = action.id,
			icon = action.icon,
			text = action.text,
			active = action.active,
			onClick = action.onClick
		})
	end

	return createElement(CanvasContainer, {
		transparency = Roact.joinBindings({
			transparency = props.transparency,
			activeTransparency = Binding.mapLerp(v2, 1, 0)
		}):map(Blend.multiply),
		size = UDim2.fromScale(0, 1),
		automaticSize = Enum.AutomaticSize.X,
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		visible = v2:map(function(p2): boolean
			return p2 > 0.025
		end)
	}, Sift.Dictionary.join(children, {
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		})
	}))
end

ToolAction = hook(ToolAction, { componentType = "PureComponent" })
return (hook(ToolActions, { componentType = "PureComponent" }))