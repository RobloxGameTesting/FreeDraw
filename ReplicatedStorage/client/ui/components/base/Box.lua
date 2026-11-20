local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local createElement = Roact.createElement

local componentPropertyForwarder = createComponentPropertyForwarder({
	color = "BackgroundColor3",
	transparency = "BackgroundTransparency",
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

local function Box(props)
	local borderThickness = props.borderThickness
		or props.borderColor
		or props.borderTransparency
		or props.borderOffset
		or props.borderPosition

	local v = componentPropertyForwarder(props, { BorderSizePixel = 0, AutoLocalize = false })

	local join = Sift.Dictionary.join
	local v2 = props[Roact.Children]
	local border

	if borderThickness then
		border = createElement("UIStroke", {
			Thickness = props.borderThickness,
			Transparency = props.borderTransparency,
			Color = props.borderColor,
			BorderOffset = props.borderOffset,
			BorderStrokePosition = props.borderPosition
		})
	end

	local corner

	if props.radius or props.circular then
		local cornerRadius

		if props.circular then
			cornerRadius = UDim.new(0.5, 0)
		else
			cornerRadius = Binding.mapAny(props.radius, function(p)
				return UDim.new(0, p)
			end)
		end

		corner = createElement("UICorner", { CornerRadius = cornerRadius })
	end

	return createElement("Frame", v, join(v2, { border = border, corner = corner }))
end

return (hook(Box, {
	componentType = "PureComponent",
	defaultProps = { color = Color3.new(1, 1, 1) }
}))