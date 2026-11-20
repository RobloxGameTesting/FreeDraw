local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local KeybindEffect = require(ReplicatedStorage.client.ui.components.effect.KeybindEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local ToolOptions = require(script.Parent.ToolOptions)

local createElement = Roact.createElement

local v = { frequency = 7, dampingRatio = 1 }

local function Tool(props, p)
	local v2 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)

	local onPress = p.useCallback(function()
		props.onSelect(props.type)
	end, { props.type })

	local v3 = {
		size = UDim2.new(0, 76, 1, 0),
		zIndex = props.active and 2 or 1
	}
	local options

	if props.optionsComponent then
		options = createElement(ToolOptions, {
			active = props.active,
			component = props.optionsComponent,
			position = UDim2.new(1, -8, 0, 8),
			zIndex = 10
		})
	end

	local children = {
		Options = options,
		Icon = createElement(Icon, {
			icon = props.icon,
			size = 36,
			color = Binding.mapLerp(v2, colors.grey[900], colors.white),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Background = createElement(Box, {
			circular = true,
			color = colors.brand,
			transparency = Binding.mapLerp(v2, 1, 0),
			size = v2:map(function(p2)
				local lerped = Number.lerp(52, 72, p2)
				return UDim2.fromOffset(lerped, lerped)
			end),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Button = createElement(Button, { [Roact.Event.Activated] = onPress }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		}),
		KeybindEffect = 0
	}
	local keybindEffect

	if props.keys then
		keybindEffect = createElement(KeybindEffect, { keys = props.keys, onPress = onPress })
	end

	children.KeybindEffect = keybindEffect
	return createElement(Container, v3, children)
end

return (hook(Tool, { componentType = "PureComponent" }))