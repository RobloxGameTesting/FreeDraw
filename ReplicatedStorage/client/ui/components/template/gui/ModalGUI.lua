local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Flipper = require(ReplicatedStorage.packages.Flipper)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local GUI = require(ReplicatedStorage.client.ui.components.base.GUI)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)

local v = { frequency = 5, dampingRatio = 0.9 }

local createElement = Roact.createElement

local function ModalGUI(props, props2)
	local v2, v3 = props2.useBinding(Vector2.new(0, 0))

	local v4, v5 = RoactFlipper.useSpring(props2, props.active and 1 or 0, v)
	props2.useEffect(function()
		if props.active then
			v5:setGoal(Flipper.Instant.new(0))
			v5:step()
			v5:setGoal(Flipper.Spring.new(1, v))
		end
	end, {})

	local state, setState = props2.useState(props.active)
	props2.useEffect(function()
		local v6 = v5:onStep(function(p)
			local v6 = p > 0.025

			if v6 ~= state then
				setState(v6)
			end
		end)

		local v7 = v5:onComplete(function()
			if props.onAnimationFinish then
				props.onAnimationFinish(v5:getValue() == 1)
			end
		end)

		return function()
			v6:disconnect()
			v7:disconnect()
		end
	end, { props.onAnimationFinish, state })

	if not (state or props.dontUnload) then
		return
	end

	local mapLerp = Binding.mapLerp(v4, 1, 0)

	local v6 = {
		zIndex = 5,
		visible = props.active or state
	}

	local v7 = {
		size = props.size or v2:map(function(p)
			return UDim2.fromOffset(p.X, p.Y)
		end),
		position = v4:map(function(p)
			return UDim2.new(0.5, 0, 0.5, Number.lerp(30, 0, p))
		end),
		anchorPoint = Vector2.new(0.5, 0.5)
	}

	local v8 = { radius = 12, transparency = mapLerp, size = UDim2.fromScale(1, 1) }
	local v9

	if props.size then
		v9 = { size = UDim2.fromScale(1, 1) }
	else
		v9 = { ["automaticSize"] = nil, automaticSize = Enum.AutomaticSize.XY }

		v9[Roact.Change.AbsoluteSize] = function(p)
			v3(p.AbsoluteSize)
		end
	end

	return createElement(GUI, v6, {
		Card = createElement(Container, v7, {
			Canvas = createElement(CanvasContainer, v8, {
				Content = createElement(Container, v9, props[Roact.Children]),
				Background = createElement(Box, { size = UDim2.fromScale(1, 1), zIndex = 0 })
			}),
			Shadow = createElement(Shadow, { transparency = mapLerp, data = shadows.low[12] }),
			Button = createElement(Button, { zIndex = -10 })
		}),
		Background = createElement(Box, {
			transparency = Binding.mapLerp(mapLerp, 0.5, 1),
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		}),
		Close = createElement(Button, { zIndex = -10, [Roact.Event.Activated] = props.onClose }),
		CursorEffects = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Base = createElement(CursorEffect),
			Top = createElement(CursorEffect, {
				type = CursorType.Pointer,
				size = v2:map(function(p)
					return UDim2.new(1, 0, 0.5, -p.Y / 2)
				end),
				position = UDim2.fromScale(0.5, 0),
				anchorPoint = Vector2.new(0.5, 0)
			}),
			Bottom = createElement(CursorEffect, {
				type = CursorType.Pointer,
				size = v2:map(function(p)
					return UDim2.new(1, 0, 0.5, -p.Y / 2)
				end),
				position = UDim2.fromScale(0.5, 1),
				anchorPoint = Vector2.new(0.5, 1)
			}),
			Left = createElement(CursorEffect, {
				type = CursorType.Pointer,
				size = v2:map(function(p)
					return UDim2.new(0.5, -p.X / 2, 1, 0)
				end),
				position = UDim2.fromScale(0, 0.5),
				anchorPoint = Vector2.new(0, 0.5)
			}),
			Right = createElement(CursorEffect, {
				type = CursorType.Pointer,
				size = v2:map(function(p)
					return UDim2.new(0.5, -p.X / 2, 1, 0)
				end),
				position = UDim2.fromScale(1, 0.5),
				anchorPoint = Vector2.new(1, 0.5)
			})
		})
	})
end

return (hook(ModalGUI, { componentType = "PureComponent" }))