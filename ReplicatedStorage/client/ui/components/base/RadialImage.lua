local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.499, 0),
	NumberSequenceKeypoint.new(0.501, 1),
	NumberSequenceKeypoint.new(1, 1)
})

local createElement = Roact.createElement

local function RadialImage(props)
	local imageSize = props.imageSize

	local binding = Binding.toBinding(props.angle)

	return createElement(Container, {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		rotation = props.rotation,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex
	}, {
		Left = createElement(Image, {
			image = props.image,
			color = props.color,
			transparency = props.transparency,
			cropSize = Vector2.new(imageSize.X / 2, imageSize.Y),
			size = UDim2.fromScale(0.5, 1),
			visible = binding:map(function(p): boolean
				return p > 0.5
			end)
		}, {
			Gradient = createElement("UIGradient", {
				Transparency = numberSequence,
				Rotation = Binding.mapLerp(binding, 0, 360),
				Offset = Vector2.new(0.5, 0),
				Enabled = binding:map(function(p): boolean
					return p > 0.5 and p < 1
				end)
			})
		}),
		Right = createElement(Image, {
			image = props.image,
			color = props.color,
			transparency = props.transparency,
			cropSize = Vector2.new(imageSize.X / 2, imageSize.Y),
			cropPosition = Vector2.new(imageSize.X / 2, 0),
			size = UDim2.fromScale(0.5, 1),
			position = UDim2.fromScale(1, 0),
			anchorPoint = Vector2.new(1, 0)
		}, {
			Gradient = createElement("UIGradient", {
				Transparency = numberSequence,
				Rotation = Binding.mapLerp(binding, 0, 360),
				Offset = Vector2.new(-0.5, 0),
				Enabled = binding:map(function(p): boolean
					return p > 0 and p < 0.5
				end)
			})
		})
	})
end

return (hook(RadialImage, {
	componentType = "PureComponent",
	defaultProps = { angle = 0 }
}))