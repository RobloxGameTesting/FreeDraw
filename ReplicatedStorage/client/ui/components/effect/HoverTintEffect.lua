local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local HoverEffect = require(ReplicatedStorage.client.ui.components.effect.HoverEffect)
local Blend = require(ReplicatedStorage.shared.lib.Blend)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function HoverTintEffect(props, p)
	local state, setState = p.useState(false)
	local v2 = RoactFlipper.useSpring(p, state and 1 or 0, v)

	return createElement(Box, {
		circular = props.circular,
		radius = props.radius,
		color = props.color,
		transparency = Binding.joinAny({ Binding.mapLerp(v2, 1, 0.9), props.transparency }):map(Blend.multiply),
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = props.zIndex
	}, {
		HoverEffect = createElement(HoverEffect, { onHover = setState })
	})
end

return (hook(HoverTintEffect, {
	componentType = "PureComponent",
	defaultProps = { color = colors.black, size = UDim2.fromScale(1, 1) }
}))