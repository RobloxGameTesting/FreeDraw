local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Arrow = require(ReplicatedStorage.client.ui.components.base.Arrow)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local IdentityType = require(ReplicatedStorage.shared.enum.IdentityType)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { frequency = 7, dampingRatio = 1 }

local v2 = {
	[IdentityType.Drawing] = "identity.type.drawing",
	[IdentityType.Claim] = "identity.type.claim"
}

local function computeUniqueColor(userId: number) -- 1 equivalent call inferred from this helper
	local v3 = bit32.bxor(userId, 12254942) * 15

	local v4 = bit32.band(bit32.rshift(v3, 16), 255)
	local v5 = bit32.band(bit32.rshift(v3, 8), 255)
	local v6 = bit32.band(v3, 255)

	return Color3.fromRGB(v4, v5, v6)
end

local createElement = Roact.createElement

local function Identity(p, p2)
	local v3, v4 = p2.useBinding(Vector2.new(0, 0))
	local position, v5 = p2.useBinding(UserInputService:GetMouseLocation())
	local active = RoactFlipper.useSpring(p2, p.identity and p.identity.active and 1 or 0, v)

	p2.useEffect(function()
		local renderSteppedConnection = RunService.RenderStepped:Connect(function()
			v5(UserInputService:GetMouseLocation())
		end)

		return function()
			renderSteppedConnection:Disconnect()
		end
	end, {})

	local mapLerp = Binding.mapLerp(active, 1, 0)
	local color

	if p.pro then
		color = colors.black:Lerp(colors.brand, 0.5)
	else
		color = colors.black
	end

	if not p.identity then
		return nil
	end

	local v6 = {
		size = v3:map(function(p3)
			return UDim2.fromOffset(p3.X, p3.Y)
		end),
		position = Roact.joinBindings({ position = position, active = active }):map(function(p3)
			return UDim2.fromOffset(p3.position.X - 20, p3.position.Y + Number.lerp(12, 24, p3.active))
		end),
		visible = active:map(function(p3): boolean
			return p3 > 0.025
		end)
	}

	local v7 = { radius = 8, transparency = mapLerp, size = UDim2.fromScale(1, 1) }
	local children = {
		Content = createElement(Container, {
			automaticSize = Enum.AutomaticSize.XY,
			[Roact.Change.AbsoluteSize] = function(p3)
				v4(p3.AbsoluteSize)
			end
		}, {
			Type = createElement(Text, {
				text = Localization.String.new(v2[p.identity.type]),
				font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
				fontSize = 14,
				color = colors.white,
				transparency = 0.25,
				layoutOrder = 1
			}),
			DisplayName = createElement(Text, {
				text = p.identity.player.DisplayName,
				font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
				fontSize = 24,
				color = colors.white,
				layoutOrder = 2
			}),
			Details = createElement(
				Container,
				{
					size = UDim2.new(0, 0, 0, 14),
					automaticSize = Enum.AutomaticSize.X,
					layoutOrder = 3
				},
				{
					Name = createElement(Text, {
						text = `@{p.identity.player.Name}`,
						font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
						fontSize = 16,
						color = colors.white,
						layoutOrder = 1
					}),
					Id = createElement(Text, {
						text = p.identity.player.UserId,
						font = Font.new(fonts.BuilderMono, Enum.FontWeight.Regular),
						fontSize = 16,
						color = colors.white,
						transparency = 0.35,
						layoutOrder = 2
					}),
					Layout = createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 8)
					})
				}
			),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6)
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12)
			})
		}),
		Color = createElement(Box, {
			radius = 4,
			color = computeUniqueColor(p.identity.player.UserId), -- inferred equivalent call
			size = UDim2.fromOffset(8, 8),
			position = UDim2.new(1, -14, 0, 14),
			anchorPoint = Vector2.new(1, 0),
			layoutOrder = 1
		}),
		Icon = 0,
		Background = 0
	}
	local icon

	if p.pro then
		icon = createElement(Icon, {
			icon = "pro",
			size = 96,
			color = colors.white,
			transparency = 0.85,
			position = UDim2.new(1, -30, 1, -30),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 0
		})
	end

	children.Icon = icon

	children.Background = createElement(Box, {
		color = color,
		transparency = 0.25,
		size = UDim2.fromScale(1, 1),
		zIndex = -1
	})
	return createElement(Container, v6, {
		Container = createElement(CanvasContainer, v7, children),
		Arrow = createElement(Arrow, {
			direction = Direction.Up,
			size = 12,
			color = color,
			transparency = Binding.mapLerp(active, 1, 0.25),
			position = UDim2.fromOffset(20, 0),
			zIndex = 0
		})
	})
end

local v3 = hook(Identity, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	local player = p.players[p.identity.player.UserId]

	local v4 = { identity = p.identity, pro = 0 }
	local pro

	if player and p.players[p.identity.player.UserId].proExpiry > os.time() then
		pro = not player.hidePro
	else
		pro = false
	end

	v4.pro = pro
	return v4
end)(v3))