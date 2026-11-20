local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Flipper = require(ReplicatedStorage.packages.Flipper)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local GUI = require(ReplicatedStorage.client.ui.components.base.GUI)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)

local v = { frequency = 4, dampingRatio = 1 }
local udim = UDim.new(1, -100)

local createElement = Roact.createElement

local function SlideGUI(props, props2)
	local v2, v3 = props2.useBinding(Vector2.new(0, 0))

	local size = Binding.toBinding(props.size or udim)

	if props.autoSize then
		size = v2:map(function(p)
			return UDim.new(0, p.Y)
		end)
	end

	local active, v4 = RoactFlipper.useSpring(props2, props.active and 1 or 0, v)
	props2.useEffect(function()
		if props.active then
			v4:setGoal(Flipper.Instant.new(0))
			v4:step()
			v4:setGoal(Flipper.Spring.new(1, v))
		end
	end, {})

	local state, setState = props2.useState(props.active)
	props2.useEffect(function()
		local v5 = v4:onStep(function(p)
			local v5 = p > 0.025

			if v5 ~= state then
				setState(v5)
			end
		end)

		return function()
			v5:disconnect()
		end
	end, { v4, state })

	if not (state or props.dontUnload) then
		return
	end

	local v5 = {
		zIndex = 10,
		enabled = props.active or state
	}

	local v6 = {
		size = size:map(function(p)
			return UDim2.new(UDim.new(1, 0), p)
		end),
		position = UDim2.fromScale(0, 1),
		anchorPoint = Binding.mapLerp(active, Vector2.new(0, 0), Vector2.new(0, 1))
	}
	local v7

	if props.autoSize then
		v7 = { ["size"] = nil, size = UDim2.fromScale(1, 0), automaticSize = Enum.AutomaticSize.Y }

		v7[Roact.Change.AbsoluteSize] = function(p)
			v3(p.AbsoluteSize)
		end
	else
		v7 = { size = UDim2.fromScale(1, 1) }
	end

	local children = {
		Card = createElement(Container, v6, {
			Content = createElement(Container, v7, props[Roact.Children]),
			Background = createElement(Box, {
				radius = 12,
				size = UDim2.new(1, 0, 1, 12),
				zIndex = 0
			}),
			Shadow = createElement(Shadow, {
				transparency = Binding.mapLerp(active, 1, 0),
				data = shadows.low[12]
			}),
			Button = createElement(Button)
		}),
		Button = 0,
		Background = 0
	}
	local button

	if props.active then
		button = createElement(Button, {
			size = Roact.joinBindings({ active = active, size = size }):map(function(p)
				return UDim2.fromScale(1, 1):Lerp(UDim2.new(UDim.new(1, 0), UDim.new(1, 0) - p.size), p.active)
			end),
			position = UDim2.fromScale(0, 0),
			anchorPoint = Vector2.new(0, 0),
			zIndex = 0,
			[Roact.Event.Activated] = props.onClose
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	children.Button = button

	children.Background = createElement(Box, {
		transparency = Binding.mapLerp(active, 1, 0.5),
		size = UDim2.fromScale(1, 1),
		zIndex = 0
	})
	return createElement(GUI, v5, children)
end

return (hook(SlideGUI, { componentType = "PureComponent" }))