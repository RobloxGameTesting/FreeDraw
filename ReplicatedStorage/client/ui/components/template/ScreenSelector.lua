local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)

local v = { frequency = 5, dampingRatio = 1 }

local createElement = Roact.createElement

local function ScreenSelector(props, p)
	local v2 = RoactFlipper.useSpring(p, props.index, v)

	return createElement(
		Container,
		{
			size = props.size,
			position = props.position,
			anchorPoint = props.anchorPoint,
			clipsDescendants = true
		},
		{
			Container = createElement(Container, {
				size = UDim2.fromScale(1, 1),
				position = v2:map(function(p2)
					return UDim2.fromScale(-(p2 - 1), 0)
				end)
			}, Sift.Dictionary.join(props[Roact.Children], {
				Layout = createElement("UIListLayout", {
					VerticalAlignment = props.alignment,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			}))
		}
	)
end

return (hook(ScreenSelector, { componentType = "PureComponent" }))