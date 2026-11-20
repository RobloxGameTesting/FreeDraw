local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local OverlayContainer = require(ReplicatedStorage.client.ui.components.base.OverlayContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local Collision = require(ReplicatedStorage.shared.lib.Collision)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local Blend = require(ReplicatedStorage.shared.lib.Blend)
local Input = require(ReplicatedStorage.shared.lib.Input)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 7, dampingRatio = 0.9 }

local v2 = newproxy(false)

local v3 = {
	[Direction.Up] = {
		offset = Vector2.new(0, -1),
		anchorPoint = Vector2.new(0.5, 1),
		position = Vector2.new(0.5, 0)
	},
	[Direction.Down] = {
		offset = Vector2.new(0, 1),
		anchorPoint = Vector2.new(0.5, 0),
		position = Vector2.new(0.5, 1)
	},
	[Direction.Left] = {
		offset = Vector2.new(-1, 0),
		anchorPoint = Vector2.new(1, 0.5),
		position = Vector2.new(0, 0.5)
	},
	[Direction.Right] = {
		offset = Vector2.new(1, 0),
		anchorPoint = Vector2.new(0, 0.5),
		position = Vector2.new(1, 0.5)
	}
}

local createElement = Roact.createElement

local function TooltipEffect(props, p)
	if not UserInputService.MouseEnabled then
		return nil
	end

	local state, setState = p.useState(v2)
	local state2, setState2 = p.useState(false)

	local v4 = RoactFlipper.useSpring(p, state2 and 1 or 0, v)
	local mapped = Roact.joinBindings({ Binding.mapLerp(v4, 1, 0), props.transparency }):map(Blend.multiply)

	p.useEffect(function()
		local heartbeatConnection = RunService.Heartbeat:Connect(function()
			local v5

			if state == v2 then
				v5 = false
			else
				v5 = os.clock() - state > 0.35
			end

			if state2 ~= v5 then
				setState2(v5)
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
		end
	end, { state, state2 })

	local v5 = v3[props.direction]

	return createElement(OverlayContainer, {
		size = props.hoverSize,
		position = props.hoverPosition,
		anchorPoint = props.hoverAnchorPoint,
		zIndex = props.zIndex,
		[Roact.Event.InputBegan] = function(p2, instance)
			if
				instance.UserInputType == Enum.UserInputType.Touch
				or instance.UserInputType == Enum.UserInputType.MouseMovement
			then
				setState(os.clock())

				local v6 = nil
				v6 = Maid.new({
					instance:GetPropertyChangedSignal("Position"):Connect(function()
						if not Collision.isPointWithinObject(instance.Position, p2) then
							setState(v2)
							v6:clean()
						end
					end),
					instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if not Input.isActive(instance) then
							setState(v2)
							v6:clean()
						end
					end)
				})
			end
		end,
		[Roact.Event.InputEnded] = function(_, p2)
			if p2.UserInputType == Enum.UserInputType.MouseMovement then
				setState(v2)
			end
		end
	}, {
		Tooltip = createElement(Box, {
			color = Color3.fromRGB(26, 26, 26),
			transparency = mapped,
			radius = 8,
			automaticSize = Enum.AutomaticSize.XY,
			position = v4:map(function(p2)
				local position = v5.position
				local v6 = v5.offset * Number.lerp(-5, 10, p2)
				return UDim2.new(position.X, v6.X, position.Y, v6.Y)
			end),
			anchorPoint = v5.anchorPoint
		}, {
			Text = createElement(Text, {
				text = props.text,
				font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
				fontSize = 18,
				color = Color3.new(1, 1, 1),
				transparency = mapped,
				constrain = props.textConstrain,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8)
			})
		})
	})
end

return (hook(TooltipEffect, {
	componentType = "PureComponent",
	defaultProps = {
		text = "Tooltip",
		direction = Direction.Up,
		hoverSize = UDim2.fromScale(1, 1),
		zIndex = 10
	}
}))