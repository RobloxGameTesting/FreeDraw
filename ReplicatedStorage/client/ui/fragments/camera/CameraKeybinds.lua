local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Input = require(ReplicatedStorage.shared.lib.Input)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function CameraKeybind(props, p)
	local state, setState = p.useState(false)
	local v2 = RoactFlipper.useSpring(p, state and 1 or 0, v)

	p.useEffect(function()
		local v3 = 0

		if props.active == nil then
			local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed and table.find(props.keyCodes, input.keyCode) then
					v3 += 1
					setState(v3 > 0)

					local userInputStateChangedConnection = nil
					userInputStateChangedConnection = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if not Input.isActive(input) then
							v3 -= 1
							setState(v3 > 0)

							userInputStateChangedConnection:Disconnect()
						end
					end)
				end
			end)

			return function()
				inputBeganConnection:Disconnect()
			end
		end

		setState(props.active)
	end, { props.active })

	local mapLerp = Binding.mapLerp(v2, colors.white, colors.black)
	local mapLerp2 = Binding.mapLerp(v2, colors.brand, colors.grey[100])

	return createElement(Box, {
		color = mapLerp2,
		radius = 4,
		size = UDim2.fromOffset(0, 24),
		automaticSize = Enum.AutomaticSize.X,
		layoutOrder = props.index
	}, {
		Label = createElement(Text, {
			text = props.label,
			color = mapLerp,
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 16,
			size = UDim2.fromScale(0, 1),
			layoutOrder = 1
		}),
		Key = createElement(Box, {
			color = mapLerp2:map(function(p2)
				return p2:Lerp(colors.black, 0.1)
			end),
			radius = 4,
			size = UDim2.fromScale(0, 1),
			automaticSize = Enum.AutomaticSize.X,
			layoutOrder = 2
		}, {
			KeyLabel = createElement(Text, {
				text = props.keyLabel,
				color = mapLerp,
				font = Font.new(fonts.Builder, Enum.FontWeight.SemiBold),
				fontSize = 16,
				size = UDim2.fromScale(0, 1)
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			})
		}),
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		Padding = createElement("UIPadding", { PaddingLeft = UDim.new(0, 8) })
	})
end

local function CameraKeybinds(props)
	return createElement(CanvasContainer, {
		transparency = props.transparency,
		size = UDim2.fromOffset(0, 24),
		automaticSize = Enum.AutomaticSize.XY,
		position = props.position,
		anchorPoint = props.anchorPoint
	}, {
		Flip = createElement(CameraKeybind, {
			active = not props.flip,
			label = Localization.String.new("camera.key.flip"),
			keyLabel = "F",
			index = 1
		}),
		Fine = createElement(CameraKeybind, {
			keyCodes = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt },
			label = Localization.String.new("camera.key.fine"),
			keyLabel = "ALT",
			index = 2
		}),
		Rotate = createElement(CameraKeybind, {
			keyCodes = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift },
			label = Localization.String.new("camera.key.rotate"),
			keyLabel = "SHIFT",
			index = 3
		}),
		Layout = createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		})
	})
end

CameraKeybind = hook(CameraKeybind, { componentType = "PureComponent" })
local v2 = hook(CameraKeybinds, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { flip = p.camera.state.flip }
end)(v2))