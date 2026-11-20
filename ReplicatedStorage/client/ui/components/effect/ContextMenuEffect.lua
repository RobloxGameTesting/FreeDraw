local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local GUI = require(ReplicatedStorage.client.ui.components.base.GUI)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local RippleEffect = require(script.Parent.RippleEffect)
local CursorEffect = require(script.Parent.CursorEffect)
local FocusEffect = require(script.Parent.FocusEffect)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Input = require(ReplicatedStorage.shared.lib.Input)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local Collision = require(ReplicatedStorage.shared.lib.Collision)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 4.5, dampingRatio = 0.9 }

local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

local createElement = Roact.createElement

local function useSize(props, mapped)
	local v2, v3 = props.useBinding({})

	props.useEffect(function()
		local value = v2:getValue()
		local v4 = {}

		for k in value do
			if not Sift.List.find(mapped, k) then
				table.insert(v4, k)
			end
		end

		v3(Sift.Dictionary.removeKeys(value, v4))
	end, { mapped })

	return v2, (props.useCallback(function(p, p2)
		v3(Sift.Dictionary.set(v2:getValue(), p, p2))
	end, {}))
end

local function ContextMenuItem(props, p)
	local v2 = p.useCallback(function()
		props.onClick(props.id)
		props.onClose()
	end, { props.onClick, props.id, props.onClose })

	local v3 = { size = UDim2.new(1, 0, 0, 36), layoutOrder = props.index }

	local v5 = {}
	v5.text = props.text
	v5.font = Font.new(fonts.Builder, Enum.FontWeight.Regular)
	v5.fontSize = 18
	local color

	if props.enabled then
		color = props.color
	else
		color = colors.grey[400]
	end

	v5.color = color

	v5.position = UDim2.new(0, props.icon and 40 or 12, 0.5, 0)
	v5.anchorPoint = Vector2.new(0, 0.5)

	v5[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
		props.onSize(props.id, p2.AbsoluteSize.X)
	end, { props.onSize, props.id })
	local v4 = {
		Text = createElement(Text, v5),
		Icon = 0,
		HoverTintEffect = 0,
		RippleEffect = 0,
		Button = 0
	}
	local icon

	if props.icon then
		icon = createElement(Icon, {
			icon = props.icon,
			size = 24,
			color = props.color,
			position = UDim2.new(0, 8, 0.5, 0),
			anchorPoint = Vector2.new(0, 0.5)
		})
	end

	v4.Icon = icon
	local hoverTintEffect

	if props.enabled then
		hoverTintEffect = createElement(HoverTintEffect, { color = colors.black })
	end

	v4.HoverTintEffect = hoverTintEffect
	local rippleEffect

	if props.enabled then
		rippleEffect = createElement(RippleEffect, { color = colors.black })
	end

	v4.RippleEffect = rippleEffect
	local button

	if props.active and props.enabled then
		button = createElement(Button, { [Roact.Event.Activated] = v2 }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	v4.Button = button
	return createElement(Container, v3, v4)
end

local function ContextMenuGroup(props, p)
	local v2, v3 = p.useBinding(Vector2.new(0, 0))

	local children = {}

	for k, item in props.items do
		children[item.id] = createElement(ContextMenuItem, {
			index = k,
			active = props.active,
			id = item.id,
			icon = item.icon,
			text = item.text,
			color = item.color,
			enabled = item.enabled,
			onClick = item.onClick,
			onClose = props.onClose,
			onSize = props.onSize
		})
	end

	return createElement(Container, {
		size = v2:map(function(p2)
			return UDim2.new(1, 0, 0, p2.Y)
		end),
		layoutOrder = props.index
	}, {
		Content = createElement(Container, {
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
				v3(p2.AbsoluteSize)
			end, {})
		}, Sift.Dictionary.join(children, {
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})),
		TopDivider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			anchorPoint = Vector2.new(0, 1)
		}),
		BottomDivider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			position = UDim2.fromScale(0, 1)
		})
	})
end

local function ContextMenu(props, props2)
	local size, v2 = props2.useBinding(Vector2.new(0, 0))
	local v3 = props2.useMemo(Roact.createRef, {})
	local active, v4 = RoactFlipper.useSpring(props2, props.active and 1 or 0, v)
	props2.useEffect(function()
		local v5 = v4:onComplete(function()
			if props.onAnimationFinished then
				props.onAnimationFinished(v4:getValue() == 1)
			end
		end)

		return function()
			v5:disconnect()
		end
	end, {})

	local sizes, onSize = useSize(props2, Sift.List.map(Sift.List.flatten(props.groups, 1), function(p)
		return p.id
	end))
	local children = {}

	for k, group in props.groups do
		children[k] = createElement(ContextMenuGroup, {
			index = k,
			active = props.active,
			items = group,
			onClose = props.onClose,
			onSize = onSize
		})
	end

	local mapLerp = Binding.mapLerp(active, 1, 0)

	if not props.rendered then
		return nil
	end

	local portal = Roact.Portal

	local v5 = {
		size = Roact.joinBindings({ sizes = sizes, size = size, active = active }):map(function(data)
			local v5 = math.max(180, math.max(0, table.unpack(Sift.Dictionary.values(data.sizes))) + 24)

			return UDim2.fromOffset(v5, data.size.Y * Number.lerp(0.75, 1, data.active))
		end),
		position = active:map(function(p)
			return UDim2.fromOffset(props.position.X, props.position.Y + Number.lerp(-10, 0, p))
		end),
		[Roact.Ref] = v3
	}
	local children2 = {
		Container = createElement(
			CanvasContainer,
			{ radius = 8, transparency = mapLerp, size = UDim2.fromScale(1, 1) },
			{
				Content = createElement(Container, {
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					[Roact.Change.AbsoluteSize] = function(p)
						v2(p.AbsoluteSize)
					end
				}, Sift.Dictionary.join(children, {
					Layout = createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 1)
					})
				})),
				Background = createElement(Box, { size = UDim2.fromScale(1, 1), zIndex = 0 })
			}
		),
		Shadow = createElement(Shadow, { transparency = mapLerp, data = shadows.low[8] }),
		CursorEffect = 0,
		FocusEffect = 0
	}
	local cursorEffect

	if props.active then
		cursorEffect = createElement(CursorEffect)
	end

	children2.CursorEffect = cursorEffect
	local focusEffect

	if props.active then
		focusEffect = createElement(FocusEffect, { onLostFocus = props.onClose })
	end

	children2.FocusEffect = focusEffect
	return createElement(portal, { target = playerGui }, {
		ContextMenuGUI = createElement(GUI, { zIndex = 10 }, {
			ContextMenu = createElement(Container, v5, children2)
		})
	})
end

local function ContextMenuEffect(props, p)
	local state, setState = p.useState(false)
	local state2, setState2 = p.useState(false)
	local state3, setState3 = p.useState(Vector2.new(0, 0))

	local onClose = p.useCallback(function()
		setState(false)
	end, {})

	return createElement(Container, {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = 10,
		[Roact.Event.InputBegan] = function(p2, instance)
			if
				instance.UserInputType == Enum.UserInputType.MouseButton2
				and instance.UserInputState == Enum.UserInputState.Begin
			then
				local userInputStateChangedConnection = nil
				userInputStateChangedConnection = instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
					if not Input.isActive(instance) then
						userInputStateChangedConnection:Disconnect()

						if Collision.isPointWithinObject(instance.Position, p2) then
							setState(true)
							setState2(true)
							setState3(Vector2.new(instance.Position.X + 1, instance.Position.Y + 1) + GuiService:GetGuiInset())
						end
					end
				end)
			end
		end
	}, {
		ContextMenu = createElement(ContextMenu, Sift.Dictionary.join(props, {
			active = state,
			rendered = state2,
			position = state3,
			onClose = onClose,
			onAnimationFinished = p.useCallback(function(p2)
				if not p2 then
					setState2(false)
				end
			end, {})
		}))
	})
end

local v2 = ContextMenuItem
ContextMenuItem = hook(v2, {
	componentType = "PureComponent",
	defaultProps = { color = colors.grey[900], enabled = true }
})

ContextMenuGroup = hook(ContextMenuGroup, { componentType = "PureComponent" })
ContextMenu = hook(ContextMenu, { componentType = "PureComponent" })
return (hook(ContextMenuEffect, {
	componentType = "PureComponent",
	defaultProps = { size = UDim2.fromScale(1, 1) }
}))