local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local images = require(ReplicatedStorage.client.ui.assets.images)

local createElement = Roact.createElement

local function Icon(props)
	return createElement(Image, {
		image = images.icons[props.size][props.icon],
		color = props.color,
		transparency = props.transparency,
		size = UDim2.fromOffset(props.size, props.size),
		position = props.position,
		anchorPoint = props.anchorPoint,
		rotation = props.rotation
	}, props[Roact.Children])
end

return (hook(Icon, {
	componentType = "PureComponent",
	defaultProps = { size = 24 }
}))