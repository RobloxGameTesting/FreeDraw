local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local TooltipEffect = require(ReplicatedStorage.client.ui.components.effect.TooltipEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local KeybindEffect = require(ReplicatedStorage.client.ui.components.effect.KeybindEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local ButtonType = require(ReplicatedStorage.shared.enum.ButtonType)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)

local createElement = Roact.createElement

local function ToolbarIconButton(props)
	local v = { size = UDim2.new(0, 52, 1, 0), layoutOrder = props.index }
	local v2 = {
		Icon = createElement(Icon, {
			icon = props.icon,
			color = props.color,
			transparency = props.enabled and 0 or 0.5,
			size = 24,
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		TooltipEffect = createElement(TooltipEffect, {
			text = props.name,
			direction = Direction.Down
		}),
		Button = 0,
		KeybindEffect = 0
	}
	local button

	if props.enabled then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer }),
			HoverTintEffect = createElement(HoverTintEffect, {
				color = colors.black,
				circular = true,
				size = UDim2.fromOffset(50, 50),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5)
			}),
			RippleEffect = createElement(RippleEffect, {
				center = true,
				scale = 1.25,
				color = colors.black
			})
		})
	end

	v2.Button = button
	local keybindEffect

	if props.keys then
		keybindEffect = createElement(KeybindEffect, { keys = props.keys, onPress = props.onClick })
	end

	v2.KeybindEffect = keybindEffect
	return createElement(Container, v, v2)
end

local function ToolbarGroup(props, p)
	local v, v2 = p.useBinding(Vector2.new(0, 0))

	local children = {}

	for k, button in props.buttons do
		if button.type == ButtonType.Icon then
			children[button.id] = createElement(ToolbarIconButton, {
				index = k * 2 - 1,
				id = button.id,
				icon = button.icon,
				enabled = button.enabled,
				name = button.name,
				color = button.color,
				keys = button.keys,
				onClick = button.onClick
			})
		end

		if k < #props.buttons then
			children[("Divider(%s)"):format(button.id)] = createElement(Box, {
				color = colors.grey[200],
				size = UDim2.new(0, 1, 1, -8),
				layoutOrder = k * 2
			}, {
				Gradient = createElement("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.25, 0),
						NumberSequenceKeypoint.new(0.75, 0),
						NumberSequenceKeypoint.new(1, 1)
					}),
					Rotation = 90
				})
			})
		end
	end

	return createElement(Container, {
		size = v:map(function(p2)
			return UDim2.fromOffset(4 + p2.X + 4, 40)
		end),
		layoutOrder = props.layoutOrder,
		active = true
	}, {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, Sift.Dictionary.join(children, {
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				[Roact.Change.AbsoluteContentSize] = function(p2)
					v2(p2.AbsoluteContentSize)
				end
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4)
			})
		})),
		Background = createElement(Box, {
			circular = true,
			color = props.color,
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		}),
		Shadow = createElement(Shadow, { data = shadows.low[40] }),
		CursorEffect = createElement(CursorEffect)
	})
end

local v = ToolbarIconButton
ToolbarIconButton = hook(v, {
	componentType = "PureComponent",
	defaultProps = { color = colors.grey[900], enabled = true }
})

return (hook(ToolbarGroup, { componentType = "PureComponent" }))