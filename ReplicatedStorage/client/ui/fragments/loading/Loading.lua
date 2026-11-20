local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local GUI = require(ReplicatedStorage.client.ui.components.base.GUI)
local Spinner = require(ReplicatedStorage.client.ui.components.base.Spinner)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local v = { frequency = 5, dampingRatio = 0.9 }

local createElement = Roact.createElement

local function Loading(p, p2)
	local v2 = RoactFlipper.useSpring(p2, p.active and 1 or 0, v)
	local mapLerp = Binding.mapLerp(v2, 1, 0)

	return createElement(GUI, {
		zIndex = 10,
		visible = v2:map(function(p3)
			return p3 > 0.025 or p.active
		end)
	}, {
		Spinner = createElement(Spinner, {
			transparency = mapLerp,
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Background = createElement(Box, {
			transparency = Binding.mapLerp(mapLerp, 0.5, 1),
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		}),
		Button = createElement(Button),
		CursorEffect = createElement(CursorEffect)
	})
end

return (hook(Loading, { componentType = "PureComponent" }))