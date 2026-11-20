local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)

local createElement = Roact.createElement

local componentPropertyForwarder = createComponentPropertyForwarder({
	size = "Size",
	automaticSize = "AutomaticSize",
	sizeConstraint = "SizeConstraint",
	position = "Position",
	anchorPoint = "AnchorPoint",
	rotation = "Rotation",
	layoutOrder = "LayoutOrder",
	active = "Active",
	clipsDescendants = "ClipsDescendants",
	zIndex = "ZIndex",
	visible = "Visible"
})

local function Container(props)
	return createElement(
		"Frame",
		componentPropertyForwarder(props, { BackgroundTransparency = 1, AutoLocalize = false }),
		props[Roact.Children]
	)
end

return (hook(Container, { componentType = "PureComponent" }))