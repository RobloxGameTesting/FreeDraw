local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)

local componentPropertyForwarder = createComponentPropertyForwarder({
	image = "Image",
	color = "ImageColor3",
	transparency = "ImageTransparency",
	cropPosition = "ImageRectOffset",
	cropSize = "ImageRectSize",
	size = "Size",
	automaticSize = "AutomaticSize",
	position = "Position",
	anchorPoint = "AnchorPoint",
	rotation = "Rotation",
	scaleType = "ScaleType",
	sliceCenter = "SliceCenter",
	tileSize = "TileSize",
	layoutOrder = "LayoutOrder",
	zIndex = "ZIndex",
	visible = "Visible"
})

local createElement = Roact.createElement

local function Image(props)
	local borderThickness = props.borderThickness or props.borderColor or props.borderTransparency

	local v = componentPropertyForwarder(props, { BackgroundTransparency = 1, AutoLocalize = false })

	local join = Sift.Dictionary.join
	local v2 = props[Roact.Children]
	local border

	if borderThickness then
		border = createElement("UIStroke", {
			Thickness = props.borderThickness or 1,
			Transparency = props.borderTransparency or 0,
			Color = props.borderColor or Color3.new(0, 0, 0)
		})
	end

	local corner

	if props.radius or props.circular then
		local cornerRadius

		if props.circular then
			cornerRadius = UDim.new(0.5, 0)
		else
			cornerRadius = UDim.new(0, props.radius)
		end

		corner = createElement("UICorner", { CornerRadius = cornerRadius })
	end

	return createElement("ImageLabel", v, join(v2, { border = border, corner = corner }))
end

return (hook(Image, { componentType = "PureComponent" }))