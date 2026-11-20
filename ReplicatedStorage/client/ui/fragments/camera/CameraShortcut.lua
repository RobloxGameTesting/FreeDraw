local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local cameraSlice = require(ReplicatedStorage.client.ui.fragments.camera.cameraSlice)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function CameraShortcut(props, p)
	local v2 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)
	local mapLerp = Binding.mapLerp(v2, 1, 0)

	local v3 = {
		size = UDim2.new(0, 220, 0, 52),
		position = props.position,
		anchorPoint = props.anchorPoint
	}
	local v4 = {
		Content = createElement(
			CanvasContainer,
			{ circular = true, transparency = mapLerp, size = UDim2.fromScale(1, 1) },
			{
				Text = createElement(Text, {
					text = Localization.String.new("camera.shortcut"),
					font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
					fontSize = 22,
					color = colors.white,
					position = UDim2.fromScale(0.5, 0.5),
					anchorPoint = Vector2.new(0.5, 0.5),
					zIndex = 2
				}),
				Icon = createElement(Icon, {
					icon = "gesture",
					size = 96,
					color = colors.white,
					transparency = 0.8,
					position = UDim2.fromScale(0.5, 0.5),
					anchorPoint = Vector2.new(0.5, 0.5)
				}),
				HoverTintEffect = createElement(HoverTintEffect, {
					color = colors.white,
					transparency = 0.5,
					radius = 8
				}),
				RippleEffect = createElement(RippleEffect, {
					color = colors.white,
					transparency = 0.5,
					radius = 8
				}),
				Background = createElement(Box, {
					color = colors.brand,
					size = UDim2.fromScale(1, 1),
					position = UDim2.fromScale(0.5, 0.5),
					anchorPoint = Vector2.new(0.5, 0.5),
					zIndex = 0,
					clipsDescendants = true
				})
			}
		),
		Button = 0,
		Shadow = 0
	}
	local button

	if props.active then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick })
	end

	v4.Button = button

	v4.Shadow = createElement(Shadow, { data = shadows.low[52], transparency = mapLerp })
	return createElement(Container, v3, v4)
end

local v2 = hook(CameraShortcut, { componentType = "PureComponent" })
return (RoactRodux.connect(nil, function(callback)
	return {
		onClick = function(_)
			callback(cameraSlice.actions.setEnabled(true))
		end
	}
end)(v2))