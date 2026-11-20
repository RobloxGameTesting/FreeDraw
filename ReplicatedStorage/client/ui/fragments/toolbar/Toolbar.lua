local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)

local groups = {
	pro = require(script.Parent.groups.ProGroup),
	history = require(script.Parent.groups.HistoryGroup),
	screens = require(script.Parent.groups.ScreensGroup),
	actions = require(script.Parent.groups.ActionsGroup),
	camera = require(script.Parent.groups.CameraGroup)
}

local udim = UDim.new(0, 20)

local createElement = Roact.createElement

local function Toolbar(props, p)
	local v, v2 = p.useBinding(Vector2.new(0, 0))

	local children = {}

	for k, group in props.groups do
		children[group] = createElement(groups[group], { layoutOrder = k })
	end

	return createElement(CanvasContainer, {
		transparency = props.transparency,
		size = v:map(function(p2)
			return UDim2.fromOffset(p2.X, 36) + UDim2.new(udim + udim, udim + udim)
		end),
		position = props.position,
		anchorPoint = props.anchorPoint
	}, Sift.Dictionary.join(children, {
		Layout = createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			[Roact.Change.AbsoluteContentSize] = function(p2)
				v2(p2.AbsoluteContentSize)
			end
		})
	}))
end

return (hook(Toolbar, {
	componentType = "PureComponent",
	defaultProps = { groups = {} }
}))