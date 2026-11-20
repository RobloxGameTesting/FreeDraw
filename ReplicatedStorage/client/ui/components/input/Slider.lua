local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Draggable = require(ReplicatedStorage.client.ui.components.base.Draggable)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)

local createElement = Roact.createElement

local function selectColorSequence(gradient, progress)
	local keypoints = gradient.Keypoints

	local v = #keypoints - 1

	for i = 1, #keypoints - 1 do
		local keypoint = keypoints[i]
		local keypoint2 = keypoints[i + 1]

		if keypoint.Time <= progress and progress < keypoint2.Time then
			v = i
			break
		end
	end

	local keypoint = keypoints[v]
	local keypoint2 = keypoints[v + 1]
	local mapped = Number.map(progress, keypoint.Time, keypoint2.Time, 0, 1)

	return keypoint.Value:Lerp(keypoint2.Value, mapped)
end

local function Slider(props)
	local mapAny = Binding.mapAny(props.value, function(p)
		return Number.map(p, props.min, props.max, 0, 1)
	end)
	local color

	if props.enabled then
		color = props.color
	else
		color = colors.grey[400]
	end

	local v = {
		size = UDim2.new(1, 0, 0, 4),
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder
	}
	local hitbox

	if props.enabled then
		hitbox = createElement(Draggable, {
			size = UDim2.new(1, 0, 0, 24),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 2,
			onPosition = function(p)
				local x = p.X
				local mapped = Number.map(x, 0, 1, props.min, props.max)

				if props.step then
					mapped = Number.round(mapped, props.step)
				end

				local v2 = math.clamp(mapped, props.min, props.max)

				props.onUpdate(v2)
			end
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	local color2

	if props.gradient then
		color2 = Binding.joinAny({ progress = mapAny, gradient = props.gradient }):map(function(p)
			return selectColorSequence(p.gradient, p.progress)
		end)
	else
		color2 = color
	end

	local children = {
		Hitbox = hitbox,
		Knob = createElement(Box, {
			circular = true,
			color = color2,
			size = UDim2.fromOffset(16, 16),
			position = Binding.mapAny(mapAny, function(p)
				return UDim2.fromScale(p, 0.5)
			end),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Background = 0
	}
	local color3

	if props.gradient then
		color3 = colors.white
	else
		color3 = colors.grey[200]
	end

	local v2 = { circular = true, color = color3, size = UDim2.fromScale(1, 1), zIndex = 0 }
	local fill

	if not props.gradient then
		fill = createElement(Box, {
			circular = true,
			color = color,
			size = Binding.mapAny(mapAny, function(p)
				return UDim2.fromScale(p, 1)
			end)
		})
	end

	local gradient

	if props.gradient then
		gradient = createElement("UIGradient", { Color = props.gradient })
	end

	children.Background = createElement(Box, v2, { Fill = fill, Gradient = gradient })
	return createElement(Container, v, children)
end

return (hook(Slider, {
	componentType = "PureComponent",
	defaultProps = {
		value = 0,
		min = 0,
		max = 1,
		enabled = true,
		color = colors.brand
	}
}))