local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local HoverEffect = require(ReplicatedStorage.client.ui.components.effect.HoverEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local images = require(ReplicatedStorage.client.ui.assets.images)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local v = { frequency = 7, dampingRatio = 1 }
local v2 = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function Checkbox(props, p)
	local state, setState = p.useState(false)

	local v3 = RoactFlipper.useSpring(p, state and 1 or 0, v2)
	local v4 = RoactFlipper.useSpring(p, props.value and 1 or 0, v)

	return createElement(
		Container,
		{
			size = UDim2.fromOffset(24, 24),
			position = props.position,
			anchorPoint = props.anchorPoint
		},
		{
			Inactive = createElement(Box, {
				transparency = 1,
				borderColor = colors.grey[400],
				borderThickness = 2,
				borderPosition = Enum.BorderStrokePosition.Inner,
				radius = 4,
				size = UDim2.fromScale(1, 1)
			}, {
				Icon = createElement(Image, {
					image = images.checkbox.inactive,
					color = colors.grey[300],
					size = UDim2.fromScale(1, 1)
				})
			}),
			Active = createElement(Box, {
				color = colors.brand,
				transparency = Binding.mapLerp(v4, 1, 0),
				radius = 4,
				size = UDim2.fromScale(1, 1),
				zIndex = 2
			}, {
				Icon = createElement(Image, {
					image = images.checkbox.active,
					transparency = Binding.mapLerp(v4, 1, 0),
					size = UDim2.fromScale(1, 1)
				})
			}),
			Hover = createElement(Box, {
				color = colors.black,
				transparency = Binding.mapLerp(v3, 1, 0.9),
				radius = 4,
				size = UDim2.fromScale(1, 1),
				zIndex = 10
			}),
			Button = createElement(Button, {
				size = UDim2.fromOffset(40, 40),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				[Roact.Event.Activated] = p.useCallback(function()
					props.onUpdate(not props.value)
				end, { props.value })
			}, {
				Cursor = createElement(CursorEffect, { type = CursorType.Pointer }),
				Hover = createElement(HoverEffect, { onHover = setState })
			})
		}
	)
end

return (hook(Checkbox, { componentType = "PureComponent" }))