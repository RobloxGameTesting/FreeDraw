local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local images = require(ReplicatedStorage.client.ui.assets.images)
local Direction = require(ReplicatedStorage.shared.enum.Direction)

local v = {
	[Direction.Up] = {
		anchor = Vector2.new(0.5, 1),
		size = Vector2.new(1, 0.5),
		crop = Vector2.new(0, 0)
	},
	[Direction.Down] = {
		anchor = Vector2.new(0.5, 0),
		size = Vector2.new(1, 0.5),
		crop = Vector2.new(0, 0.5)
	},
	[Direction.Left] = {
		anchor = Vector2.new(1, 0.5),
		size = Vector2.new(0.5, 1),
		crop = Vector2.new(0.5, 0)
	},
	[Direction.Right] = {
		anchor = Vector2.new(0, 0.5),
		size = Vector2.new(0.5, 1),
		crop = Vector2.new(0.5, 0)
	}
}

local createElement = Roact.createElement

local function Arrow(props)
	local v2 = v[props.direction]

	local anchor = v2.anchor
	local v3 = v2.size * props.size
	local v4 = v2.crop * props.size

	return createElement(Image, {
		image = images.arrow[props.size],
		color = props.color,
		transparency = props.transparency,
		cropSize = v3 * 2,
		cropPosition = v4 * 2,
		size = UDim2.fromOffset(v3.X, v3.Y),
		position = props.position,
		anchorPoint = anchor,
		zIndex = props.zIndex
	}, props[Roact.Children])
end

return (hook(Arrow, {
	componentType = "PureComponent",
	defaultProps = { direction = Direction.Up }
}))