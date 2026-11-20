local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Flipper = require(ReplicatedStorage.packages.Flipper)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local Binding = require(ReplicatedStorage.shared.lib.Binding)
local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local HoverEffect = require(ReplicatedStorage.client.ui.components.effect.HoverEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local String = require(ReplicatedStorage.shared.lib.String)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { frequency = 5, dampingRatio = 1 }

local LocalPlayer = Players.LocalPlayer

local createElement = Roact.createElement

local function ProStatus(props, props2)
	local v2 = props.proExpiry - os.time() > 0

	local v3 = RoactFlipper.useMotor(props2, 0)
	local binding = RoactFlipper.getBinding(v3)

	local v4, v5 = props2.useBinding(0)
	local v6, v7 = props2.useBinding(0)
	props2.useEffect(function()
		if v2 then
			local renderSteppedConnection = RunService.RenderStepped:Connect(function()
				v5(math.map(math.sin(os.clock() * 3.141592653589793 / 1.1), -1, 1, 0, 1))
				v7(props.proExpiry - os.time())
			end)

			return function()
				renderSteppedConnection:Disconnect()
			end
		end

		v5(0)
		v7(0)

		return nil
	end, { props.proExpiry })

	local detailsSize, v8 = props2.useBinding(Vector2.new(0, 0))

	local v9 = {
		position = props.position,
		anchorPoint = props.anchorPoint,
		size = Roact.joinBindings({ hover = binding, detailsSize = detailsSize }):map(function(p)
			return UDim2.fromOffset(52 + (p.detailsSize.X + 16) * p.hover, 52)
		end),
		clipsDescendants = true,
		zIndex = 10
	}
	local color

	if v2 then
		color = Binding.mapLerp(binding, colors.brand, colors.white)
	else
		color = colors.grey[300]
	end

	local children = {
		Icon = createElement(Icon, {
			icon = "pro",
			size = 28,
			color = color,
			transparency = not v2 and 0 or Binding.mapLerp(v4, 0, 0.35),
			position = UDim2.new(1, -12, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5)
		}),
		Details = createElement(Container, {
			size = detailsSize:map(function(p)
				return UDim2.new(0, p.X, 1, 0)
			end),
			position = UDim2.new(1, -52, 0, 0),
			anchorPoint = Vector2.new(1, 0)
		}, {
			Label = createElement(Text, {
				text = Localization.String.new("pro.timeRemaining"),
				font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
				fontSize = 14,
				color = colors.white,
				layoutOrder = 1
			}),
			Time = createElement(Text, {
				text = v6:map(function(p)
					return String.duration(p)
				end),
				font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
				fontSize = 24,
				color = colors.white,
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 2),
				[Roact.Change.AbsoluteContentSize] = props2.useCallback(function(p)
					v8(p.AbsoluteContentSize)
				end, {})
			})
		}),
		Border = 0,
		Box = 0,
		Hover = 0
	}
	local border

	if v2 then
		border = createElement(Box, {
			borderThickness = 1,
			borderTransparency = Binding.mapLerp(binding, 0.75, 1),
			borderColor = colors.brand,
			transparency = 1,
			circular = true,
			size = UDim2.new(1, -2, 1, -2),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 2
		})
	end

	children.Border = border
	local box

	if v2 then
		box = createElement(Box, {
			color = colors.brand,
			transparency = Binding.mapLerp(binding, 1, 0),
			circular = true,
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		})
	end

	children.Box = box

	children.Hover = createElement(HoverEffect, {
		onHover = props2.useCallback(function(p)
			v3:setGoal(Flipper.Spring.new(p and v2 and 1 or 0, v))
		end, { v2 })
	})
	return createElement(Container, v9, children)
end

local v2 = hook(ProStatus, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	local player = p.players[LocalPlayer.UserId]

	return { proStart = player.proStart, proExpiry = player.proExpiry }
end)(v2))