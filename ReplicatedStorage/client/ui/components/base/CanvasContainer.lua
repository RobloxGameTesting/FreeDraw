local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Container = require(script.Parent.Container)

local createElement = Roact.createElement

local componentPropertyForwarder = createComponentPropertyForwarder({
	color = "GroupColor3",
	transparency = "GroupTransparency",
	size = "Size",
	automaticSize = "AutomaticSize",
	sizeConstraint = "SizeConstraint",
	position = "Position",
	anchorPoint = "AnchorPoint",
	rotation = "Rotation",
	layoutOrder = "LayoutOrder",
	active = "Active",
	zIndex = "ZIndex",
	visible = "Visible"
})

local function CanvasContainer(props, p)
	local borderThickness = props.borderThickness or props.borderColor or props.borderTransparency

	local state, setState = p.useState(false)

	local v = componentPropertyForwarder(props, {
		Size = Binding.mapAny(props.size, function(p2)
			if p2.X.Offset > 0 and p2.Y.Offset > 0 then
				return p2
			end

			if not p2 then
				return nil
			end

			if state then
				return p2
			end

			return p2 + UDim2.fromOffset(1, 1)
		end),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		AutoLocalize = false,
		[Roact.Ref] = p.useMemo(function()
			return function()
				task.defer(function()
					setState(true)
				end)
			end
		end, {})
	})
	local join = Sift.Dictionary.join
	local v2 = {
		InnerContentHackyPatch = createElement(
			Container,
			{ size = UDim2.fromScale(1, 1), clipsDescendants = true },
			props[Roact.Children]
		),
		border = 0,
		corner = 0
	}
	local border

	if borderThickness then
		border = createElement("UIStroke", {
			Thickness = props.borderThickness or 1,
			Transparency = props.borderTransparency or 0,
			Color = props.borderColor or Color3.new(0, 0, 0)
		})
	end

	v2.border = border
	local corner

	if props.radius or props.circular then
		local cornerRadius

		if props.circular then
			cornerRadius = UDim.new(0.5, 0)
		else
			cornerRadius = Binding.mapAny(props.radius, function(p2)
				return UDim.new(0, p2)
			end)
		end

		corner = createElement("UICorner", { CornerRadius = cornerRadius })
	end

	v2.corner = corner
	return createElement("CanvasGroup", v, join({}, v2))
end

return (hook(CanvasContainer, { componentType = "PureComponent" }))