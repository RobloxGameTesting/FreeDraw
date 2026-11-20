local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local v = { frequency = 5, dampingRatio = 1 }

local createElement = Roact.createElement

local function PlayerListBackground(props, p)
	local v2 = RoactFlipper.useSpring(p, props.topRounded and 1 or 0, v)
	local v3 = RoactFlipper.useSpring(p, props.bottomRounded and 1 or 0, v)

	local mapped = Binding.mapLerp(v2, 0, 8):map(math.round)
	local mapped2 = Binding.mapLerp(v3, 0, 8):map(math.round)

	return createElement(Container, {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex
	}, {
		TopContainer = createElement(Container, {
			size = mapped:map(function(p2)
				return UDim2.new(1, 0, 0, p2)
			end),
			clipsDescendants = true
		}, {
			Top = createElement(Box, {
				color = props.color,
				transparency = props.transparency,
				radius = mapped,
				size = mapped:map(function(p2)
					return UDim2.new(1, 0, 0, p2 * 2)
				end)
			})
		}),
		BottomContainer = createElement(Container, {
			size = mapped:map(function(p2)
				return UDim2.new(1, 0, 1, -p2)
			end),
			position = UDim2.fromScale(0, 1),
			anchorPoint = Vector2.new(0, 1),
			clipsDescendants = true
		}, {
			Bottom = createElement(Box, {
				color = props.color,
				transparency = props.transparency,
				radius = mapped2,
				size = mapped2:map(function(p2)
					return UDim2.new(1, 0, 1, p2)
				end),
				position = UDim2.fromScale(0, 1),
				anchorPoint = Vector2.new(0, 1)
			})
		})
	})
end

return (hook(PlayerListBackground, { componentType = "PureComponent" }))