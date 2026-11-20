local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.packages.Roact)
local Flipper = require(ReplicatedStorage.packages.Flipper)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(script.Parent.Container)
local Box = require(script.Parent.Box)
local Button = require(script.Parent.Button)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Input = require(ReplicatedStorage.shared.lib.Input)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local colors = require(ReplicatedStorage.client.ui.assets.colors)

local v = { frequency = 7, dampingRatio = 1 }
local v2 = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function ScrollBar(props, p)
	local mapPluck = Binding.mapPluck(props.containerSize, props.axis)
	local contentSize = props.contentSize
	local contentPosition = props.contentPosition

	local mapped = Roact.joinBindings({ containerSize = mapPluck, contentSize = contentSize }):map(function(p2)
		return p2.containerSize / p2.contentSize
	end)

	local mapped2 = Roact.joinBindings({
		containerSize = mapPluck,
		contentSize = contentSize,
		contentPosition = contentPosition
	}):map(function(data)
		return data.contentPosition / math.max(data.contentSize - data.containerSize, 0)
	end)

	local mapped3 = Roact.joinBindings({ size = mapped, position = mapped2 }):map(function(p2)
		if p2.position < 0 then
			return p2.size - (0 - p2.position)
		end

		if p2.position > 1 then
			return p2.size - (p2.position - 1)
		end

		return p2.size
	end)

	local mapped4 = mapped2:map(function(value)
		return (math.clamp(value, 0, 1))
	end)

	local state, setState = p.useState(false)
	local v3 = RoactFlipper.useSpring(p, state and 1 or 0, v)

	local v4 = p.useCallback(function(p2, instance)
		local v4 = instance.UserInputType == Enum.UserInputType.MouseButton1
		local v5 = instance.UserInputType == Enum.UserInputType.Touch

		if (v4 or v5) and instance.UserInputState == Enum.UserInputState.Begin then
			local v6 = instance.Position
			local function onMove(position) -- 2 equivalent calls inferred from this helper
				local v7 = position - v6
				props.onMove(v7[props.axis] / p2.AbsoluteSize[props.axis] * contentSize:getValue())
				v6 = position
			end

			local v7 = Maid.new()

			if v4 then
				v7:giveTask(UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						onMove(input.Position) -- inferred equivalent call
					end
				end))
			elseif v5 then
				v7:giveTask(instance:GetPropertyChangedSignal("Position"):Connect(function()
					onMove(instance.Position) -- inferred equivalent call
				end))
			end

			v7:giveTask(instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
				if not Input.isActive(instance) then
					v7:clean()
				end
			end))
		end
	end, { props.axis })

	if props.axis == "X" then
		error("TODO")
		return
	end

	if props.axis ~= "Y" then
		return
	end

	return createElement(Container, {
		size = UDim2.new(0, 12, 1, 0),
		position = UDim2.fromScale(1, 0),
		anchorPoint = Vector2.new(1, 0),
		zIndex = props.zIndex,
		visible = mapped3:map(function(p2): boolean
			return p2 < 1
		end)
	}, {
		BarContainer = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Bar = createElement(Box, {
				circular = true,
				color = colors.black,
				transparency = Binding.mapLerp(v3, 0.75, 0.5),
				size = mapped3:map(function(p2)
					return UDim2.fromScale(1, p2)
				end),
				position = mapped4:map(function(p2)
					return UDim2.fromScale(0, p2)
				end),
				anchorPoint = mapped4:map(function(p2)
					return Vector2.new(0, p2)
				end)
			}),
			Padding = createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4)
			})
		}),
		Button = createElement(Button, {
			size = UDim2.fromScale(1, 1),
			[Roact.Event.MouseEnter] = p.useCallback(function()
				setState(true)
			end, {}),
			[Roact.Event.MouseLeave] = p.useCallback(function()
				setState(false)
			end, {}),
			[Roact.Event.InputBegan] = v4
		})
	})
end

local function ScrollContainer(props, props2)
	local containerSize, v3 = props2.useBinding(Vector2.new(0, 0))
	local binding = Binding.toBinding(props.contentSize)

	local v4 = props2.useValue(0)
	local v5 = RoactFlipper.useMotor(props2, v4.value)
	local binding2 = RoactFlipper.getBinding(v5)
	local function inheritPositionFromTarget() -- 3 equivalent calls inferred from this helper
		v5:setGoal(Flipper.Instant.new(v4.value))
		v5:step(0)
	end
	local function inheritPositionFromMotor() -- 2 equivalent calls inferred from this helper
		v4.value = v5:getValue()
	end
	local function getContentPositionBounds()
		return 0, (math.max(binding:getValue() - containerSize:getValue()[props.axis], 0))
	end

	local v6 = props2.useValue(props.scrollEnabled)
	props2.useEffect(function()
		v6.value = props.scrollEnabled
	end, { props.scrollEnabled })
	local v7 = props2.useValue(props.dragEnabled)
	props2.useEffect(function()
		v7.value = props.dragEnabled
	end, { props.dragEnabled })

	local v8 = {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = props.zIndex,
		active = true,
		clipsDescendants = props.clipsDescendants,
		[Roact.Change.AbsoluteSize] = props2.useCallback(function(p)
			v3(p.AbsoluteSize)
		end, {}),
		[Roact.Event.InputChanged] = props2.useCallback(function(_, p)
			if p.UserInputType == Enum.UserInputType.MouseWheel and v6.value then
				v4.value += -p.Position.Z * 2 * 50
				v4.value = math.clamp(v4.value, getContentPositionBounds())
				v5:setGoal(Flipper.Spring.new(v4.value, v2))
			end
		end, {}),
		[Roact.Event.InputBegan] = props2.useCallback(function(_, instance)
			if
				instance.UserInputType == Enum.UserInputType.Touch
				and instance.UserInputState == Enum.UserInputState.Begin
			then
				inheritPositionFromMotor() -- inferred equivalent call
				inheritPositionFromTarget() -- inferred equivalent call
				local v8 = instance.Position[props.axis]

				local v9 = nil
				v9 = Maid.new({
					instance:GetPropertyChangedSignal("Position"):Connect(function()
						local v10 = instance.Position[props.axis]
						local v11 = v10 - v8

						if v7.value then
							v4.value += -v11
							v4.value = math.clamp(v4.value, getContentPositionBounds())
							inheritPositionFromTarget() -- inferred equivalent call
						end

						v8 = v10
					end),
					instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if not Input.isActive(instance) then
							v9:clean()
						end
					end)
				})
			end
		end, { props.axis })
	}

	local v9 = {
		size = Roact.joinBindings({ contentSize = binding, containerSize = containerSize }):map(function(p)
			if props.axis == "X" then
				return UDim2.new(0, math.max(p.contentSize, p.containerSize.X), 1, 0)
			end

			if props.axis == "Y" then
				return UDim2.new(1, 0, 0, (math.max(p.contentSize, p.containerSize.Y)))
			end
		end),
		position = binding2:map(function(p)
			if props.axis == "X" then
				return UDim2.fromOffset(-p, 0)
			end

			if props.axis == "Y" then
				return UDim2.fromOffset(0, -p)
			end
		end)
	}
	local join = Sift.Dictionary.join
	local v10 = props[Roact.Children]
	local padding

	if props.scrollBarInset > 0 then
		padding = createElement("UIPadding", {
			[props.axis == "X" and "PaddingBottom" or "PaddingRight"] = Roact.joinBindings({
				contentSize = binding,
				containerSize = containerSize
			}):map(function(p)
				if p.contentSize > p.containerSize[props.axis] then
					return UDim.new(0, props.scrollBarInset)
				end

				return UDim.new(0, 0)
			end)
		})
	end

	return createElement(Container, v8, {
		Content = createElement(Container, v9, join(v10, { Padding = padding })),
		ScrollBar = createElement(ScrollBar, {
			containerSize = containerSize,
			contentSize = binding,
			contentPosition = binding2,
			axis = props.axis,
			zIndex = 10,
			onMove = props2.useCallback(function(p)
				if v6.value then
					inheritPositionFromMotor() -- inferred equivalent call
					v4.value += p
					v4.value = math.clamp(v4.value, getContentPositionBounds())
					inheritPositionFromTarget() -- inferred equivalent call
				end
			end, {})
		})
	})
end

ScrollBar = hook(ScrollBar, { componentType = "PureComponent" })
return (hook(ScrollContainer, {
	componentType = "PureComponent",
	defaultProps = {
		axis = "Y",
		scrollEnabled = true,
		dragEnabled = true,
		clipsDescendants = true,
		scrollBarInset = 0
	}
}))