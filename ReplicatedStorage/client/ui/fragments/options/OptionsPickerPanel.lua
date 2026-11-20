local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local KeybindEffect = require(ReplicatedStorage.client.ui.components.effect.KeybindEffect)
local Color = require(script.Parent.optionComponents.Color)
local Thickness = require(script.Parent.optionComponents.Thickness)
local Transparency = require(script.Parent.optionComponents.Transparency)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local toolboxSlice = require(ReplicatedStorage.client.ui.fragments.toolbox.toolboxSlice)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)

local h = Enum.KeyCode.H

local v = { frequency = 6, dampingRatio = 1 }

local createElement = Roact.createElement

local function OptionsSliders(p)
	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = p.layoutOrder
		},
		{
			Thickness = createElement(Thickness, { layoutOrder = 1 }),
			Transparency = createElement(Transparency, { layoutOrder = 2 }),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20)
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20)
			})
		}
	)
end

local function OptionsButton(props, p)
	local v2 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)

	local v3 = { size = UDim2.fromOffset(36, 36), layoutOrder = props.layoutOrder }
	local v4 = {
		Icon = createElement(Icon, {
			size = 24,
			icon = props.icon,
			color = Binding.mapLerp(v2, colors.grey[900], colors.white),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		HoverTintEffect = createElement(HoverTintEffect, {
			radius = 8,
			transparency = props.transparency,
			zIndex = 0
		}),
		Background = createElement(Box, {
			radius = 8,
			color = colors.brand,
			transparency = Binding.mapLerp(v2, 1, 0),
			borderColor = Binding.mapLerp(v2, colors.grey[400], colors.brand),
			size = UDim2.fromScale(1, 1),
			zIndex = -1
		}),
		Button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		}),
		KeybindEffect = 0
	}
	local keybindEffect

	if props.keys then
		keybindEffect = createElement(KeybindEffect, { keys = props.keys, onPress = props.onClick })
	end

	v4.KeybindEffect = keybindEffect
	return createElement(Container, v3, v4)
end

local function OptionsPickerPanel(props, p)
	return createElement(Container, {
		size = props.size or UDim2.fromScale(1, 0),
		position = props.position,
		automaticSize = Enum.AutomaticSize.Y,
		layoutOrder = props.layoutOrder,
		[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
			props.onSize(p2.AbsoluteSize)
		end, { props.onSize })
	}, {
		Color = createElement(Color, { layoutOrder = 1 }),
		Sliders = createElement(OptionsSliders, { layoutOrder = 2 }),
		Buttons = createElement(Container, { size = UDim2.new(1, 0, 0, 36), layoutOrder = 3 }, {
			Eyedropper = createElement(OptionsButton, {
				icon = "eyedropper",
				keys = { h },
				active = props.eyedropperActive,
				layoutOrder = 1,
				onClick = props.onEyedropper
			}),
			Manual = createElement(OptionsButton, {
				icon = "textEntry",
				active = props.manual,
				layoutOrder = 2,
				onClick = props.onManual
			}),
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20)
			})
		}),
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 32)
		}),
		Padding = createElement("UIPadding", {
			PaddingTop = UDim.new(0, 20),
			PaddingBottom = UDim.new(0, 20)
		})
	})
end

OptionsSliders = hook(OptionsSliders, { componentType = "PureComponent" })
OptionsButton = hook(OptionsButton, { componentType = "PureComponent" })
local v2 = hook(OptionsPickerPanel, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		eyedropperActive = p.toolbox.selectedTool == ToolType.Eyedropper
	}
end, function(callback)
	return {
		onEyedropper = function()
			callback(toolboxSlice.actions.setTool(ToolType.Eyedropper))
		end
	}
end)(v2))