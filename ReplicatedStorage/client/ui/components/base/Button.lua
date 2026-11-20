local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)

local componentPropertyForwarder = createComponentPropertyForwarder({
	size = "Size",
	automaticSize = "AutomaticSize",
	sizeConstraint = "SizeConstraint",
	position = "Position",
	anchorPoint = "AnchorPoint",
	active = "Active",
	zIndex = "ZIndex"
})

local createElement = Roact.createElement

local function Button(props)
	return createElement(
		"ImageButton",
		componentPropertyForwarder(props, {
			Image = "",
			BackgroundTransparency = 1,
			AutoLocalize = false
		}),
		props[Roact.Children]
	)
end

return (hook(Button, {
	componentType = "PureComponent",
	defaultProps = {
		size = UDim2.fromScale(1, 1),
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5)
	}
}))