local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Number = require(ReplicatedStorage.shared.lib.Number)
local colorSlice = require(script.Parent.Parent.optionSlices.colorSlice)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Draggable = require(ReplicatedStorage.client.ui.components.base.Draggable)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local images = require(ReplicatedStorage.client.ui.assets.images)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local KeybindEffect = require(ReplicatedStorage.client.ui.components.effect.KeybindEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local x = Enum.KeyCode.X

local function normalizePosition(p) -- 2 equivalent calls inferred from this helper
	return p * 2 - Vector2.new(1, 1)
end

local function hueWheelShape(p): boolean
	local magnitude = normalizePosition(p).Magnitude -- inferred equivalent call
	return magnitude <= 1 and magnitude >= 0.82
end

local createElement = Roact.createElement

local function ColorPreview(props)
	return createElement(
		Container,
		{
			size = UDim2.fromOffset(props.size, props.size),
			position = props.position,
			anchorPoint = props.anchorPoint,
			zIndex = props.zIndex
		},
		{
			Primary = createElement(Box, {
				color = props.primary,
				borderThickness = 1,
				borderColor = colors.grey[900],
				circular = true,
				size = UDim2.fromScale(1, 1),
				position = UDim2.fromScale(0.65, 0.35),
				anchorPoint = Vector2.new(0.5, 0.5)
			}),
			Secondary = createElement(Box, {
				color = props.secondary,
				borderThickness = 1,
				borderColor = colors.grey[900],
				circular = true,
				zIndex = -1,
				size = UDim2.fromScale(1, 1),
				position = UDim2.fromScale(0.35, 0.65),
				anchorPoint = Vector2.new(0.5, 0.5)
			}),
			Button = createElement(
				Button,
				{
					size = UDim2.fromScale(1.3, 1.3),
					position = UDim2.fromScale(0.5, 0.5),
					anchorPoint = Vector2.new(0.5, 0.5),
					[Roact.Event.Activated] = props.onClick
				},
				{
					CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
				}
			),
			KeybindEffect = createElement(KeybindEffect, {
				keys = { x },
				onPress = props.onClick
			})
		}
	)
end

local function ColorCursor(p)
	return createElement(Box, {
		color = colors.white,
		circular = true,
		borderColor = colors.black,
		borderThickness = 2,
		size = UDim2.fromOffset(8, 8),
		position = p.position,
		anchorPoint = Vector2.new(0.5, 0.5),
		zIndex = p.zIndex
	})
end

local function ColorHueWheel(props, p)
	return createElement(
		Image,
		{
			image = images.options.colors.hueWheel,
			size = UDim2.fromScale(1, 1),
			zIndex = props.zIndex
		},
		{
			Button = createElement(Draggable, {
				onBegin = hueWheelShape,
				onPosition = p.useCallback(function(p2)
					local position = normalizePosition(p2) -- inferred equivalent call
					local v = -math.atan2(position.X, position.Y)
					props.onChange(Number.map(v, -3.141592653589793, 3.141592653589793, 0, 1))
				end, { props.onChange })
			}),
			Cursor = createElement(ColorCursor, {
				position = props.hue:map(function(p2)
					return UDim2.fromScale(
						Number.map(math.sin(p2 * 3.141592653589793 * 2) * Number.lerp(0.82, 1, 0.5), -1, 1, 0, 1),
						Number.map(-math.cos(p2 * 3.141592653589793 * 2) * Number.lerp(0.82, 1, 0.5), -1, 1, 0, 1)
					)
				end),
				zIndex = props.zIndex + 1
			}),
			CursorEffect = createElement(CursorEffect, {
				type = CursorType.Pointer,
				shape = hueWheelShape
			})
		}
	)
end

local function ColorSaturationValueSquare(props, p)
	return createElement(
		Container,
		{
			size = props.size,
			position = props.position,
			anchorPoint = props.anchorPoint,
			zIndex = props.zIndex
		},
		{
			Button = createElement(Draggable, {
				onPosition = p.useCallback(function(p2)
					props.onChange(math.clamp(p2.X, 0, 1), (math.clamp(1 - p2.Y, 0, 1)))
				end, { props.onChange })
			}, {
				CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
			}),
			Cursor = createElement(ColorCursor, {
				position = Roact.joinBindings({ saturation = props.saturation, value = props.value }):map(function(p2)
					return UDim2.fromScale(p2.saturation, 1 - p2.value)
				end),
				zIndex = 3
			}),
			ValueGradient = createElement(
				Box,
				{ color = colors.black, radius = 8, size = UDim2.fromScale(1, 1), zIndex = 2 },
				{
					Gradient = createElement("UIGradient", {
						Transparency = NumberSequence.new(1, 0),
						Rotation = 90
					})
				}
			),
			SaturationGradient = createElement(Box, {
				color = props.hue:map(function(p2)
					return Color3.fromHSV(p2, 1, 1)
				end),
				radius = 8,
				size = UDim2.fromScale(1, 1),
				zIndex = 1
			}, {
				Gradient = createElement("UIGradient", { Transparency = NumberSequence.new(1, 0) })
			}),
			Background = createElement(Box, {
				color = colors.white,
				radius = 8,
				size = UDim2.fromScale(1, 1),
				zIndex = 0
			})
		}
	)
end

local function ColorSelector(props, p)
	local mapPluck = Binding.mapPluck(props.color, "hsv")

	return createElement(Container, {
		size = UDim2.fromOffset(200, 200),
		layoutOrder = props.layoutOrder
	}, {
		ColorHueWheel = createElement(ColorHueWheel, {
			hue = Binding.mapPluck(mapPluck, "hue"),
			zIndex = 1,
			onChange = p.useCallback(function(p2)
				props.setHSV(p2, nil, nil)
			end, { props.setHSV })
		}),
		ColorSaturationValueSquare = createElement(ColorSaturationValueSquare, {
			hue = Binding.mapPluck(mapPluck, "hue"),
			saturation = Binding.mapPluck(mapPluck, "saturation"),
			value = Binding.mapPluck(mapPluck, "value"),
			size = UDim2.fromOffset(100, 100),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 2,
			onChange = p.useCallback(function(p2, p3)
				props.setHSV(nil, p2, p3)
			end, { props.setHSV })
		}),
		ColorPreview = createElement(ColorPreview, {
			primary = Binding.mapPluck(props.color, "primary"),
			secondary = Binding.mapPluck(props.color, "secondary"),
			size = 24,
			position = UDim2.new(1, 0, 1, 0),
			anchorPoint = Vector2.new(1, 1),
			zIndex = 3,
			onClick = props.swap
		})
	})
end

local function Color(props)
	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = props.layoutOrder
		},
		{
			ColorSelector = createElement(ColorSelector, {
				color = props.color,
				setRGB = props.setRGB,
				setHSV = props.setHSV,
				swap = props.swap,
				layoutOrder = 1
			}),
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			})
		}
	)
end

ColorPreview = hook(ColorPreview, { componentType = "PureComponent" })
ColorCursor = hook(ColorCursor, { componentType = "PureComponent" })
ColorHueWheel = hook(ColorHueWheel, { componentType = "PureComponent" })
ColorSaturationValueSquare = hook(ColorSaturationValueSquare, { componentType = "PureComponent" })
ColorSelector = hook(ColorSelector, { componentType = "PureComponent" })
local v = hook(Color, { componentType = "PureComponent" })

local bindingConverter = Binding.createBindingConverter(v, { "color" })

return (RoactRodux.connect(function(p)
	return { color = p.options.color }
end, function(callback)
	return {
		setRGB = function(p, p2, p3)
			callback(colorSlice.actions.setRGB(p, p2, p3))
		end,
		setHSV = function(p, p2, p3)
			callback(colorSlice.actions.setHSV(p, p2, p3))
		end,
		swap = function()
			callback(colorSlice.actions.swap())
		end
	}
end)(bindingConverter))