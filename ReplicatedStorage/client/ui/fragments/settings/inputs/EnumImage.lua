local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local HoverEffect = require(ReplicatedStorage.client.ui.components.effect.HoverEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)

local v = { frequency = 7, dampingRatio = 1 }
local v2 = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function EnumImageItem(props, p)
	local state, setState = p.useState(false)

	local v3 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)
	local v4 = RoactFlipper.useSpring(p, state and 1 or 0, v2)

	return createElement(Image, { image = props.image, radius = 4, layoutOrder = props.index }, {
		Active = createElement(
			Box,
			{
				color = colors.brand,
				radius = 4,
				transparency = Binding.mapLerp(v3, 1, 0.35),
				size = UDim2.fromScale(1, 1)
			},
			{
				Icon = createElement(Icon, {
					size = 24,
					icon = "check",
					transparency = Binding.mapLerp(v3, 1, 0),
					position = UDim2.fromScale(0.5, 0.5),
					anchorPoint = Vector2.new(0.5, 0.5)
				})
			}
		),
		Hover = createElement(Box, {
			color = Color3.new(0.5, 0.5, 0.5),
			radius = 4,
			transparency = Binding.mapLerp(v4, 1, 0.75),
			size = UDim2.fromScale(1, 1),
			zIndex = 2
		}),
		Button = createElement(Button, {
			[Roact.Event.Activated] = p.useCallback(function()
				props.onUpdate(props.id)
			end, { props.onUpdate, props.id })
		}, {
			Cursor = createElement(CursorEffect, { type = CursorType.Pointer }),
			Hover = createElement(HoverEffect, { onHover = setState })
		})
	})
end

local function EnumImage(props)
	local children = {}
	local name = nil

	for k, item in props.items do
		local active = props.value == item.id

		if active then
			name = item.name
		end

		children[item.id] = createElement(EnumImageItem, {
			id = item.id,
			active = active,
			image = item.image,
			size = props.size,
			index = k,
			onUpdate = props.onUpdate
		})
	end

	local v3 = { automaticSize = Enum.AutomaticSize.Y, size = UDim2.fromScale(1, 0) }
	local v4 = {
		Options = createElement(
			Container,
			{ automaticSize = Enum.AutomaticSize.Y, size = UDim2.fromScale(1, 0), layoutOrder = 1 },
			Sift.Dictionary.join(children, {
				Layout = createElement("UIGridLayout", {
					CellSize = UDim2.fromOffset(props.size, props.size),
					CellPadding = UDim2.fromOffset(4, 4),
					StartCorner = Enum.StartCorner.TopRight,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			})
		),
		Label = 0,
		Layout = 0
	}
	local label

	if name then
		label = createElement(Text, {
			text = name,
			font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
			fontSize = 16,
			color = colors.grey[600],
			layoutOrder = 2
		})
	end

	v4.Label = label

	v4.Layout = createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8)
	})
	return createElement(Container, v3, v4)
end

EnumImageItem = hook(EnumImageItem, { componentType = "PureComponent" })
return (hook(EnumImage, { componentType = "PureComponent" }))