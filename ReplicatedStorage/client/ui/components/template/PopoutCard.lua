local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local OverlayContainer = require(ReplicatedStorage.client.ui.components.base.OverlayContainer)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local images = require(ReplicatedStorage.client.ui.assets.images)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local Alignment = require(ReplicatedStorage.shared.enum.Alignment)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)

local v = { frequency = 7, dampingRatio = 1 }

local Down = Direction.Down
local v3 = { size = Vector2.new(16, 8), crop = Vector2.new(0, 8), position = 0, anchorPoint = 0 }
local udims = {
	[Alignment.Start] = UDim2.new(0, 24, 1, 0),
	[Alignment.Center] = UDim2.new(0.5, 0, 1, 0),
	[Alignment.End] = UDim2.new(1, -24, 1, 0)
}
v3.position = udims

v3.anchorPoint = Vector2.new(0.5, 0)
local v2 = { [Down] = v3 }

local Up = Direction.Up
local v5 = { offset = Vector2.new(0, -1), position = 0, anchorPoint = 0 }
local udims2 = {
	[Alignment.Start] = UDim2.new(0.5, -24, 0, 0),
	[Alignment.Center] = UDim2.new(0.5, 0, 0, 0),
	[Alignment.End] = UDim2.new(0.5, 24, 0, 0)
}
v5.position = udims2

local vector2s = {
	[Alignment.Start] = Vector2.new(0, 1),
	[Alignment.Center] = Vector2.new(0.5, 1),
	[Alignment.End] = Vector2.new(1, 1)
}
v5.anchorPoint = vector2s
local v4 = { [Up] = v5 }

local v6 = {
	[Direction.Up] = { container = v4[Direction.Up], arrow = v2[Direction.Down] }
}

local createElement = Roact.createElement

local function PopoutCard(props, p)
	local v7 = v6[props.direction]
	local container = v7.container
	local arrow = v7.arrow

	local v8 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)
	local v9, v10 = p.useBinding(Vector2.new(0, 0))
	local mapLerp = Binding.mapLerp(v8, 1, 0)

	return createElement(OverlayContainer, { size = UDim2.fromScale(1, 1) }, {
		Popout = createElement(Container, {
			size = v9:map(function(p2)
				return UDim2.fromOffset(p2.X, p2.Y)
			end),
			position = v8:map(function(p2)
				return container.position[props.alignment] + UDim2.fromOffset(
					container.offset.X * props.offset * p2,
					container.offset.Y * props.offset * p2
				)
			end),
			anchorPoint = container.anchorPoint[props.alignment],
			zIndex = props.zIndex,
			visible = v8:map(function(p2): boolean
				return p2 > 0.025
			end)
		}, {
			Container = createElement(
				CanvasContainer,
				{ radius = 8, transparency = mapLerp, size = UDim2.fromScale(1, 1) },
				{
					Content = createElement(
						Container,
						{ size = UDim2.fromScale(1, 1) },
						Sift.Dictionary.join(props[Roact.Children], {
							Layout = createElement("UIListLayout", {
								[Roact.Change.AbsoluteContentSize] = p.useCallback(function(p2)
									v10(p2.AbsoluteContentSize)
								end, {})
							})
						})
					),
					Background = createElement(Box, { size = UDim2.fromScale(1, 1), zIndex = 0 })
				}
			),
			Arrow = createElement(Image, {
				image = images.arrow[16],
				transparency = mapLerp,
				cropPosition = arrow.crop * 2,
				cropSize = arrow.size * 2,
				size = UDim2.fromOffset(arrow.size.X, arrow.size.Y),
				position = arrow.position[props.alignment],
				anchorPoint = arrow.anchorPoint,
				zIndex = 0
			}),
			Shadow = createElement(Shadow, { transparency = mapLerp, data = shadows.low[8] }),
			CursorEffect = createElement(CursorEffect),
			Button = createElement(Button)
		})
	})
end

return (hook(PopoutCard, {
	componentType = "PureComponent",
	defaultProps = { direction = Direction.Up, alignment = Alignment.Center, offset = 32 }
}))