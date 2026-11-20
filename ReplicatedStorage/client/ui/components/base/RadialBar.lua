local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local createElement = Roact.createElement

local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.499, 1),
	NumberSequenceKeypoint.new(0.501, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local numberSequence2 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.499, 0),
	NumberSequenceKeypoint.new(0.501, 1),
	NumberSequenceKeypoint.new(1, 1)
})

local function RadialBar(props)
	local binding = Binding.toBinding(props.value)

	local v = {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex
	}

	local v2 = {
		size = UDim2.fromScale(0.5, 1),
		clipsDescendants = true,
		visible = binding:map(function(p): boolean
			if props.clockwise then
				return p > 0.5
			end

			return p > 0
		end)
	}

	local v3 = {
		circular = true,
		transparency = 1,
		size = UDim2.new(2, -props.thickness * 2, 1, -props.thickness * 2),
		position = UDim2.fromScale(1, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5)
	}

	local v4 = {
		Color = props.color,
		Thickness = props.thickness,
		Transparency = props.transparency
	}
	local transparency

	if props.clockwise then
		transparency = numberSequence2
	else
		transparency = numberSequence
	end

	local children = {
		Left = createElement(Container, v2, {
			Circle = createElement(Box, v3, {
				Stroke = createElement("UIStroke", v4, {
					Gradient = createElement("UIGradient", {
						Transparency = transparency,
						Rotation = Binding.mapLerp(binding, 0, props.clockwise and 360 or -360),
						Enabled = binding:map(function(p): boolean
							if props.clockwise then
								return p > 0.5 and p < 1
							end

							return p > 0 and p < 0.5
						end)
					})
				})
			})
		}),
		Right = 0
	}

	local v5 = {
		size = UDim2.fromScale(0.5, 1),
		position = UDim2.fromScale(1, 0),
		anchorPoint = Vector2.new(1, 0),
		clipsDescendants = true,
		visible = binding:map(function(p): boolean
			if props.clockwise then
				return p > 0
			end

			return p > 0.5
		end)
	}

	local v6 = {
		circular = true,
		transparency = 1,
		size = UDim2.new(2, -props.thickness * 2, 1, -props.thickness * 2),
		position = UDim2.fromScale(0, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5)
	}

	local v7 = {
		Color = props.color,
		Thickness = props.thickness,
		Transparency = props.transparency
	}
	local transparency2

	if props.clockwise then
		transparency2 = numberSequence2
	else
		transparency2 = numberSequence
	end

	children.Right = createElement(Container, v5, {
		Circle = createElement(Box, v6, {
			Stroke = createElement("UIStroke", v7, {
				Gradient = createElement("UIGradient", {
					Transparency = transparency2,
					Rotation = Binding.mapLerp(binding, 0, props.clockwise and 360 or -360),
					Enabled = binding:map(function(p): boolean
						if props.clockwise then
							return p > 0 and p < 0.5
						end

						return p > 0.5 and p < 1
					end)
				})
			})
		})
	})
	return createElement(Container, v, children)
end

return (hook(RadialBar, {
	componentType = "PureComponent",
	defaultProps = { value = 0, clockwise = true }
}))