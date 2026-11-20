local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local OverlayContainer = require(ReplicatedStorage.client.ui.components.base.OverlayContainer)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 6, dampingRatio = 1 }

local createElement = Roact.createElement

local function DropdownItem(props)
	local v2 = { size = UDim2.new(1, 0, 0, 40), layoutOrder = props.layoutOrder }

	local v3 = { size = UDim2.fromScale(1, 1) }
	local icon

	if props.icon then
		icon = createElement(Icon, {
			icon = props.icon,
			size = 24,
			color = colors.grey[900],
			transparency = props.placeholder and 0.5 or 0,
			layoutOrder = 1
		})
	end

	local children = {
		Content = createElement(Container, v3, {
			Icon = icon,
			Text = createElement(Text, {
				text = props.text,
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				fontSize = 20,
				color = colors.grey[900],
				transparency = props.placeholder and 0.5 or 0,
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			Padding = createElement("UIPadding", { PaddingLeft = UDim.new(0, 12) })
		}),
		RippleEffect = createElement(RippleEffect, {
			radius = props.radius,
			color = colors.grey[700]
		}),
		HoverTintEffect = createElement(HoverTintEffect, {
			radius = props.radius,
			color = colors.grey[700]
		}),
		Button = 0
	}
	local button

	if props.active then
		button = createElement(Button, {
			[Roact.Event.Activated] = function()
				props.onSelect(props.id)
			end
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	children.Button = button
	return createElement(Container, v2, children)
end

local function DropdownPopout(props, p)
	local open = RoactFlipper.useSpring(p, props.open and 1 or 0, v)
	local mapLerp = Binding.mapLerp(open, 1, 0)
	local size, v2 = p.useBinding(Vector2.new(0, 0))

	local children = {}

	for k, item in props.items do
		children[item.id] = createElement(DropdownItem, {
			id = item.id,
			text = item.text,
			icon = item.icon,
			active = props.open,
			layoutOrder = k,
			onSelect = props.onSelect
		})
	end

	local v3 = {
		size = Roact.joinBindings({ open = open, size = size }):map(function(p2)
			return UDim2.new(1, 0, 0, p2.size.Y * Number.lerp(0.75, 1, p2.open))
		end),
		zIndex = 10,
		visible = open:map(function(p2): boolean
			return p2 > 0.025
		end)
	}

	local children2 = {
		Container = createElement(
			CanvasContainer,
			{ radius = 8, transparency = mapLerp, size = UDim2.fromScale(1, 1) },
			{
				Content = createElement(Container, {
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
						v2(p2.AbsoluteSize)
					end, {})
				}, Sift.Dictionary.join(children, {
					Layout = createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				})),
				Background = createElement(Box, {
					radius = 8,
					size = UDim2.fromScale(1, 1),
					zIndex = 0
				})
			}
		),
		Shadow = createElement(Shadow, { transparency = mapLerp, data = shadows.low[8] }),
		Button = 0
	}
	local button

	if props.open then
		button = createElement(Button, { zIndex = -10 })
	end

	children2.Button = button
	return createElement(OverlayContainer, v3, children2)
end

local function Dropdown(props, p)
	local state, setState = p.useState(false)
	local borderTransparency = RoactFlipper.useSpring(p, state and 1 or 0, v)

	local where = Sift.List.findWhere(props.items, function(p2): boolean
		return p2.id == props.selection
	end)

	local v2 = props.items[where] or props.placeholder

	local onSelect = p.useCallback(function(p2)
		setState(false)
		props.onSelect(p2)
	end, { props.onSelect })

	return createElement(Container, {
		size = UDim2.new(props.size, UDim.new(0, 40)),
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex
	}, {
		Popout = createElement(DropdownPopout, {
			open = state,
			items = props.items,
			onSelect = onSelect,
			onClose = p.useCallback(function()
				setState(false)
			end, {})
		}),
		Selection = createElement(DropdownItem, {
			id = v2.id,
			text = v2.text,
			icon = v2.icon,
			active = not state,
			placeholder = where == nil,
			radius = 8,
			onSelect = p.useCallback(function()
				setState(true)
			end, {})
		}),
		Border = createElement(Box, {
			radius = 8,
			borderColor = colors.grey[300],
			borderTransparency = borderTransparency,
			transparency = 1,
			size = UDim2.fromScale(1, 1)
		})
	})
end

DropdownItem = hook(DropdownItem, { componentType = "PureComponent" })
DropdownPopout = hook(DropdownPopout, { componentType = "PureComponent" })
return (hook(Dropdown, {
	componentType = "PureComponent",
	defaultProps = { size = UDim.new(0, 200) }
}))