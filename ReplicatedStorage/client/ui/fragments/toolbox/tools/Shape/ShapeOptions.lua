local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Dropdown = require(ReplicatedStorage.client.ui.components.input.Dropdown)
local Slider = require(ReplicatedStorage.client.ui.components.input.Slider)
local LabelDecoration = require(ReplicatedStorage.client.ui.components.input.decoration.LabelDecoration)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local GeometryType = require(ReplicatedStorage.shared.enum.GeometryType)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local shapeSlice = require(script.Parent.shapeSlice)

local v = {
	[GeometryType.Circle] = {},
	[GeometryType.Rectangle] = {},
	[GeometryType.Polygon] = { polygonVertices = true },
	[GeometryType.Star] = { polygonVertices = true, polygonInnerRadius = true }
}

local createElement = Roact.createElement

local function ShapeOptions(props, p)
	local v2 = { size = UDim2.fromOffset(240, 0), automaticSize = Enum.AutomaticSize.Y }
	local children = {
		GeometryType = createElement(
			LabelDecoration,
			{
				label = Localization.String.new("toolbox.shape.options.geometryType.label"),
				zIndex = -1,
				layoutOrder = 1
			},
			{
				Dropdown = createElement(Dropdown, {
					selection = props.geometryType,
					items = p.useMemo(function()
						return {
							{
								id = GeometryType.Circle,
								text = Localization.String.new("toolbox.shape.options.geometryType.selection.circle"),
								icon = "circle"
							},
							{
								id = GeometryType.Rectangle,
								text = Localization.String.new("toolbox.shape.options.geometryType.selection.rectangle"),
								icon = "rectangle"
							},
							{
								id = GeometryType.Polygon,
								text = Localization.String.new("toolbox.shape.options.geometryType.selection.polygon"),
								icon = "pentagon"
							},
							{
								id = GeometryType.Star,
								text = Localization.String.new("toolbox.shape.options.geometryType.selection.star"),
								icon = "star"
							}
						}
					end, {}),
					onSelect = props.setGeometryType,
					size = UDim.new(1, 0)
				})
			}
		),
		PolygonVertices = 0,
		PolygonInnerRadius = 0,
		Layout = 0,
		Padding = 0
	}
	local polygonVertices

	if v[props.geometryType].polygonVertices then
		polygonVertices = createElement(
			LabelDecoration,
			{
				label = Localization.String.new("toolbox.shape.options.polygonVertices.label"),
				value = props.polygonVertices,
				layoutOrder = 2
			},
			{
				Slider = createElement(Slider, {
					value = props.polygonVertices,
					min = 3,
					max = 10,
					step = 1,
					onUpdate = props.setPolygonVertices
				})
			}
		)
	end

	children.PolygonVertices = polygonVertices
	local polygonInnerRadius

	if v[props.geometryType].polygonInnerRadius then
		polygonInnerRadius = createElement(LabelDecoration, {
			label = Localization.String.new("toolbox.shape.options.polygonInnerRadius.label"),
			value = ("%d%%"):format(props.polygonInnerRadius * 100),
			layoutOrder = 2
		}, {
			Slider = createElement(Slider, {
				value = props.polygonInnerRadius,
				min = 0,
				max = 0.9,
				step = 0.01,
				onUpdate = props.setPolygonInnerRadius
			})
		})
	end

	children.PolygonInnerRadius = polygonInnerRadius

	children.Layout = createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 16)
	})

	children.Padding = createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 16),
		PaddingRight = UDim.new(0, 16),
		PaddingTop = UDim.new(0, 16),
		PaddingBottom = UDim.new(0, 16)
	})
	return createElement(Container, v2, children)
end

local v2 = hook(ShapeOptions, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	local options = p.toolbox.tools[ToolType.Shape].options
	return {
		geometryType = options.geometryType,
		polygonVertices = options.polygonVertices,
		polygonInnerRadius = options.polygonInnerRadius
	}
end, function(callback)
	return {
		setGeometryType = function(geometryType)
			callback(shapeSlice.actions.setOptions({ geometryType = geometryType }))
		end,
		setPolygonVertices = function(polygonVertices)
			callback(shapeSlice.actions.setOptions({ polygonVertices = polygonVertices }))
		end,
		setPolygonInnerRadius = function(polygonInnerRadius)
			callback(shapeSlice.actions.setOptions({ polygonInnerRadius = polygonInnerRadius }))
		end
	}
end)(v2))