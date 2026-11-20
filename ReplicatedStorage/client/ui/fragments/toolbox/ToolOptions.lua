local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local PopoutCard = require(ReplicatedStorage.client.ui.components.template.PopoutCard)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local createElement = Roact.createElement

local v = { frequency = 7, dampingRatio = 1 }

local function ToolOptions(props, p)
	local v2 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)

	local state, setState = p.useState(false)
	p.useEffect(function()
		if state and not props.active then
			setState(false)
		end
	end, { state, props.active })

	local v3 = {
		size = Binding.mapLerp(v2, 24, 32):map(function(p2)
			return UDim2.fromOffset(p2, p2)
		end),
		position = props.position,
		anchorPoint = Vector2.new(0.5, 0.5),
		zIndex = props.zIndex
	}
	local v4 = {
		Popout = createElement(PopoutCard, { active = state, zIndex = 10 }, {
			Options = createElement(props.component)
		}),
		Icon = createElement(Icon, {
			icon = "settings",
			size = 20,
			transparency = Binding.mapLerp(v2, 1, 0),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Background = createElement(Box, {
			color = colors.brand:Lerp(colors.white, 0.25),
			circular = true,
			transparency = Binding.mapLerp(v2, 1, 0),
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		}),
		RippleEffect = 0,
		Button = 0
	}
	local rippleEffect

	if props.active then
		rippleEffect = createElement(RippleEffect, { center = true })
	end

	v4.RippleEffect = rippleEffect
	local button

	if props.active then
		button = createElement(Button, {
			[Roact.Event.Activated] = function()
				setState(function(p2): boolean
					return not p2
				end)
			end
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	v4.Button = button
	return createElement(Container, v3, v4)
end

return (hook(ToolOptions, { componentType = "PureComponent" }))