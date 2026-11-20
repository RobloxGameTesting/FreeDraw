local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Field = require(ReplicatedStorage.client.ui.components.input.Field)

local createElement = Roact.createElement

local function FieldDecoration(props)
	return createElement(
		Container,
		{
			size = UDim2.new(UDim.new(1, 0), props.size.Y),
			position = props.position,
			anchorPoint = props.anchorPoint,
			layoutOrder = props.layoutOrder
		},
		{
			Field = createElement(Field, {
				value = props.value,
				filter = props.filter,
				onUpdate = props.onUpdate,
				size = UDim2.new(props.size.X, UDim.new(1, 0))
			}),
			Children = createElement(Container, {
				size = UDim2.fromScale(1, 1) - UDim2.new(props.size.X, nil) - UDim2.fromOffset(props.spacing, 0),
				position = UDim2.fromScale(1, 0),
				anchorPoint = Vector2.new(1, 0)
			}, Sift.Dictionary.join(props[Roact.Children], {
				Layout = createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				})
			}))
		}
	)
end

return (hook(FieldDecoration, {
	componentType = "PureComponent",
	defaultProps = { size = UDim2.fromOffset(52, 24), spacing = 16 }
}))