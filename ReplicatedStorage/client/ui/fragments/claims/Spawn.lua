local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { frequency = 5, dampingRatio = 1 }

local createElement = Roact.createElement

local function Spawn(p, p2)
	local v2 = RoactFlipper.useSpring(p2, p.highlight and 1 or 0, v)

	local mapLerp = Binding.mapLerp(v2, colors.brand, colors.red[700])
	local mapLerp2 = Binding.mapLerp(v2, 1, 10)

	return createElement("Part", {
		Anchored = true,
		CanCollide = false,
		CanTouch = false,
		Size = Vector3.new(p.radius * 2, 1, p.radius * 2),
		CFrame = CFrame.new(0, -0.5, 0) * CFrame.fromEulerAnglesXYZ(0, -1.5707963267948966, 0),
		Transparency = 1
	}, {
		GUI = createElement(
			"SurfaceGui",
			{
				Face = Enum.NormalId.Top,
				SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
				PixelsPerStud = 20,
				AlwaysOnTop = true
			},
			{
				Text = createElement(Container, { size = UDim2.fromScale(1, 1), zIndex = 2 }, {
					Primary = createElement(Text, {
						text = Localization.String.new("claim.spawn.primary"),
						font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
						fontSize = 72,
						color = colors.red[900],
						transparency = Binding.mapLerp(v2, 1, 0),
						layoutOrder = 1
					}),
					Secondary = createElement(Text, {
						text = Localization.String.new("claim.spawn.secondary"),
						font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
						fontSize = 36,
						color = colors.red[900],
						transparency = Binding.mapLerp(v2, 1, 0),
						layoutOrder = 2
					}),
					Layout = createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12)
					})
				}),
				Circle = createElement(Box, {
					circular = true,
					color = mapLerp,
					transparency = Binding.mapLerp(v2, 1, 0.85),
					borderColor = mapLerp,
					borderThickness = mapLerp2,
					borderTransparency = Binding.mapLerp(v2, 0.65, 0),
					size = mapLerp2:map(function(p3)
						return UDim2.new(1, -(p3 * 2), 1, -(p3 * 2))
					end),
					position = UDim2.fromScale(0.5, 0.5),
					anchorPoint = Vector2.new(0.5, 0.5)
				})
			}
		)
	})
end

local v2 = hook(Spawn, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		highlight = p.toolbox.selectedTool == ToolType.Claim
	}
end)(v2))