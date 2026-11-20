local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local TextButton = require(ReplicatedStorage.client.ui.components.button.TextButton)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local colors = require(ReplicatedStorage.client.ui.assets.colors)

local createElement = Roact.createElement

local function MultiTextButton(props, p)
	local v, v2 = p.useBinding(Vector2.new(0, 0))

	local count = #props.buttons
	local children = {}
	local children2 = {}

	for k, button in props.buttons do
		local id = button.id
		local v3 = {
			text = button.text,
			style = ButtonStyle.Flat,
			size = 0,
			layoutOrder = 0,
			onClick = 0
		}
		local size

		if props.size then
			size = UDim2.new(1 / count, -(count - 1), 1, 0)
		end

		v3.size = size
		v3.layoutOrder = k * 2
		v3.onClick = button.onClick
		children[id] = createElement(TextButton, v3)

		if k < count then
			children2[("Line(%d)"):format(k)] = createElement(Box, {
				color = colors.grey[300],
				size = UDim2.new(0, 1, 0.75, 0),
				layoutOrder = k * 2 + 1
			}, {
				Gradient = createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.2, 0),
						NumberSequenceKeypoint.new(0.8, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			})
		end
	end

	return createElement(Container, {
		size = props.size or v:map(function(p2)
			return UDim2.fromOffset(p2.X, 36)
		end),
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex
	}, Sift.Dictionary.join(props[Roact.Children], {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, Sift.Dictionary.join(children, children2, {
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				[Roact.Change.AbsoluteContentSize] = p.useCallback(function(p2)
					v2(p2.AbsoluteContentSize)
				end, {})
			})
		})),
		Background = createElement(Box, {
			radius = 8,
			borderColor = colors.grey[300],
			transparency = 1,
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		})
	}))
end

return (hook(MultiTextButton, { componentType = "PureComponent" }))