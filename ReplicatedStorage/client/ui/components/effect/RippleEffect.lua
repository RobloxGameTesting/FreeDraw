local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Flipper = require(ReplicatedStorage.packages.Flipper)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Blend = require(ReplicatedStorage.shared.lib.Blend)
local Input = require(ReplicatedStorage.shared.lib.Input)

local v = { frequency = 7, dampingRatio = 1 }
local v2 = { frequency = 2, dampingRatio = 1 }

local createElement = Roact.createElement

local function getOpposingCorner(position) -- 1 equivalent call inferred from this helper
	return Vector2.new(math.round(1 - position.X), (math.round(1 - position.Y)))
end

local function RippleEffect(props, props2)
	local v3 = props2.useValue(false)

	local v4 = RoactFlipper.useMotor(props2, 0)
	local v5 = RoactFlipper.useMotor(props2, 0)

	local binding = RoactFlipper.getBinding(v4)
	local binding2 = RoactFlipper.getBinding(v5)
	local position, v6 = props2.useBinding(Vector2.new(0.5, 0.5))
	local aspectRatio, v7 = props2.useBinding(Vector2.new(0, 0))

	local mapped = Binding.joinAny({ Binding.mapLerp(binding2, 1, 0), props.transparency }):map(Blend.multiply)

	props2.useEffect(function()
		local v8 = v4:onStep(function(p)
			if not v3.value and p > 0.96 then
				v5:setGoal(Flipper.Spring.new(0, v2))
			end
		end)

		return function()
			v8:disconnect()
		end
	end, {})

	local v8 = {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = props.zIndex,
		[Roact.Change.AbsoluteSize] = props2.useCallback(function(p)
			local absoluteSize = p.AbsoluteSize
			v7(absoluteSize / math.max(absoluteSize.X, absoluteSize.Y))
		end, {}),
		[Roact.Event.InputBegan] = props2.useCallback(function(p, instance)
			local userInputType = instance.UserInputType

			if
				(userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.MouseButton2 or userInputType == Enum.UserInputType.MouseButton3 or userInputType == Enum.UserInputType.Touch)
				and instance.UserInputState == Enum.UserInputState.Begin
			then
				v3.value = true

				v6((Vector2.new(instance.Position.X, instance.Position.Y) - p.AbsolutePosition) / p.AbsoluteSize)

				v4:setGoal(Flipper.Instant.new(0))
				v5:setGoal(Flipper.Instant.new(0))
				v4:step(0)
				v5:step(0)

				v4:setGoal(Flipper.Spring.new(1), v)
				v5:setGoal(Flipper.Spring.new(1), v)

				local userInputStateChangedConnection = nil
				userInputStateChangedConnection = instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
					if not Input.isActive(instance) then
						v3.value = false
						userInputStateChangedConnection:Disconnect()

						if v4:getValue() > 0.96 then
							v5:setGoal(Flipper.Spring.new(0, v2))
						end
					end
				end)
			end
		end, {})
	}

	local v9 = {
		size = UDim2.fromScale(1, 1),
		radius = props.radius,
		circular = props.circular,
		visible = mapped:map(function(p): boolean
			return p < 0.975
		end)
	}
	local circle

	if props.center then
		circle = createElement(Box, {
			color = props.color,
			transparency = Binding.mapLerp(mapped, 0.8, 1),
			circular = true,
			size = binding:map(function(p)
				local v10 = p * props.scale
				return UDim2.fromScale(v10, v10)
			end),
			sizeConstraint = aspectRatio:map(function(p)
				if p.X < p.Y then
					return Enum.SizeConstraint.RelativeXX
				end

				return Enum.SizeConstraint.RelativeYY
			end),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		})
	else
		circle = createElement(Box, {
			color = props.color,
			transparency = Binding.mapLerp(mapped, 0.8, 1),
			circular = true,
			size = Roact.joinBindings({
				progress = binding,
				position = position,
				aspectRatio = aspectRatio
			}):map(function(data)
				local magnitude = (data.position * data.aspectRatio - getOpposingCorner(data.position) * data.aspectRatio).Magnitude -- inferred equivalent call
				local v10 = Number.lerp(magnitude * 0.1, magnitude * 1.01, data.progress) * 2 * props.scale
				return UDim2.fromScale(v10, v10)
			end),
			position = position:map(function(p)
				return UDim2.fromScale(p.X, p.Y)
			end),
			sizeConstraint = aspectRatio:map(function(p)
				if p.X > p.Y then
					return Enum.SizeConstraint.RelativeXX
				end

				return Enum.SizeConstraint.RelativeYY
			end),
			anchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	return createElement(Container, v8, {
		Canvas = createElement(CanvasContainer, v9, { Circle = circle })
	})
end

return (hook(RippleEffect, {
	componentType = "PureComponent",
	defaultProps = { scale = 1, size = UDim2.fromScale(1, 1), zIndex = 10 }
}))