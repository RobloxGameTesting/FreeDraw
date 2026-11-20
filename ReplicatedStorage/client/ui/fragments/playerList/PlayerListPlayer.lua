local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local enumerator = require(ReplicatedStorage.packages.enumerator)
local Sift = require(ReplicatedStorage.packages.Sift)
local Color = require(ReplicatedStorage.packages.Color)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local config = require(ReplicatedStorage.shared.data.config)
local PlayerListPopout = require(script.Parent.PlayerListPopout)
local PlayerListBackground = require(script.Parent.PlayerListBackground)
local PointerType = require(ReplicatedStorage.shared.enum.PointerType)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = enumerator("RevealMode", { "Hover", "Active" })

local v2 = { frequency = 5, dampingRatio = 1 }
local v3 = { frequency = 5, dampingRatio = 1 }
local v4 = { frequency = 5, dampingRatio = 1 }

local isStudio = RunService:IsStudio()
local LocalPlayer = Players.LocalPlayer

local createElement = Roact.createElement

local function PlayerListPlayer(props, p)
	local state, setState = p.useState(false)
	local hover = RoactFlipper.useSpring(p, state and 1 or 0, v2)
	local v5 = RoactFlipper.useSpring(p, props.active and 1 or 0, v3)
	local v6 = RoactFlipper.useSpring(p, props.visible and 1 or 0, v4)

	local v7 = props.hideRole and "player" or props.role
	local role = config.group.roles[v7]

	local v8 = LocalPlayer.UserId == props.id
	local v9

	if props.proExpiry > os.time() then
		v9 = not props.hidePro
	else
		v9 = false
	end

	local onClose = p.useCallback(function()
		props.onClick(props.id)
	end, { props.onClick, props.id })

	local black = colors.black
	local v10 = colors.black

	if v9 then
		black = black:Lerp(colors.brand, 0.5)
		v10 = colors.brand
	end

	if role.special then
		v10 = role.color
	end

	local v11

	if Color.GetPerceivedBrightness(black) >= 0.5 then
		v11 = colors.black
	else
		v11 = colors.white
	end

	local v12

	if Color.GetPerceivedBrightness(v10) >= 0.5 then
		v12 = colors.black
	else
		v12 = colors.white
	end

	local mapLerp = Binding.mapLerp(v5, black, v10)
	local mapLerp2 = Binding.mapLerp(v5, v11, v12)
	local transparency

	if props.revealMode == v.Hover then
		transparency = hover
	else
		transparency = v5
	end

	local v13 = {
		size = v5:map(function(p2)
			return UDim2.new(1, 0, 0, Number.lerp(36, 68, p2))
		end),
		zIndex = Binding.mapLerp(v5, 0, 100),
		layoutOrder = props.layoutOrder
	}

	local v14 = {
		["size"] = nil,
		["size"] = nil,
		["size"] = nil,
		["size"] = nil,
		size = v5:map(function(p2)
			return UDim2.new(1, 0, 0, Number.lerp(36, 52, p2))
		end)
	}
	local position

	if props.compact then
		position = UDim2.fromScale(1, 0.5)
	else
		position = v5:map(function(p2)
			return UDim2.new(1, Number.lerp(0, -8, p2), 0.5, 0)
		end)
	end

	v14.position = position

	v14.anchorPoint = Vector2.new(1, 0.5)

	v14[Roact.Event.MouseEnter] = p.useCallback(function()
		setState(true)
	end, {})

	v14[Roact.Event.MouseLeave] = p.useCallback(function()
		setState(false)
	end, {})

	local v15 = { transparency = Binding.mapLerp(v6, 0.85, 0), size = UDim2.fromScale(1, 1) }

	local v16 = { size = UDim2.fromScale(1, 1), clipsDescendants = true }

	local v17 = {
		text = props.displayName .. (props.verified and "" or ""),
		font = 0,
		fontSize = 18,
		color = 0,
		transparency = 0,
		position = 0,
		anchorPoint = 0
	}
	local font

	if v8 then
		font = Font.new(fonts.Builder, Enum.FontWeight.Medium)
	else
		font = Font.new(fonts.Builder, Enum.FontWeight.Regular)
	end

	v17.font = font

	v17.color = mapLerp2
	v17.transparency = transparency

	v17.position = transparency:map(function(p2)
		return UDim2.new(0, Number.lerp(12, -12, p2), 0, 18)
	end)

	v17.anchorPoint = Vector2.new(0, 0.5)
	local children2 = { DisplayName = createElement(Text, v17), Name = 0 }

	local v18 = {
		text = "@" .. props.name,
		font = 0,
		fontSize = 18,
		color = 0,
		transparency = 0,
		position = 0,
		anchorPoint = 0
	}
	local font2

	if v8 then
		font2 = Font.new(fonts.Builder, Enum.FontWeight.Medium)
	else
		font2 = Font.new(fonts.Builder, Enum.FontWeight.Regular)
	end

	v18.font = font2

	v18.color = mapLerp2
	v18.transparency = Binding.mapLerp(transparency, 1, 0)

	v18.position = transparency:map(function(p2)
		return UDim2.new(0, Number.lerp(36, 12, p2), 0, 18)
	end)

	v18.anchorPoint = Vector2.new(0, 0.5)
	children2.Name = createElement(Text, v18)
	local children = {
		NameContainer = createElement(Container, v16, children2),
		Rank = createElement(Text, {
			text = Localization.String.new(("role.%s"):format(v7)),
			font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
			fontSize = 14,
			color = mapLerp2,
			transparency = Binding.mapLerp(v5, 1, 0),
			position = UDim2.new(0, 12, 1, -9),
			anchorPoint = Vector2.new(0, 1)
		}),
		Icons = 0,
		Popout = 0,
		Button = 0,
		Local = 0,
		RippleEffect = 0,
		Background = 0
	}

	local v19 = { size = UDim2.new(1, 0, 0, 36) }
	local friend

	if props.friend then
		friend = createElement(Icon, {
			icon = "smiley",
			size = 20,
			color = mapLerp2,
			layoutOrder = 2
		})
	end

	local blocked

	if props.blocked then
		blocked = createElement(Icon, {
			icon = "cancel",
			size = 20,
			color = mapLerp2,
			layoutOrder = 3
		})
	end

	local muted

	if props.muted then
		muted = createElement(Icon, { icon = "", size = 20, color = mapLerp2, layoutOrder = 4 })
	end

	local hidden

	if props.hidden then
		hidden = createElement(Icon, {
			icon = "eyeOff",
			size = 20,
			color = mapLerp2,
			layoutOrder = 5
		})
	end

	local pro

	if v9 then
		pro = createElement(Icon, { icon = "pro", size = 20, color = mapLerp2, layoutOrder = 6 })
	end

	children.Icons = createElement(Container, v19, {
		Friend = friend,
		Blocked = blocked,
		Muted = muted,
		Hidden = hidden,
		Pro = pro,
		Layout = createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		Padding = createElement("UIPadding", { PaddingRight = UDim.new(0, 8) })
	})

	children.Popout = createElement(PlayerListPopout, Sift.Dictionary.join(props, {
		self = props.id == LocalPlayer.UserId and not isStudio,
		onClose = onClose
	}))
	local button

	if props.visible then
		button = createElement(Button, { [Roact.Event.Activated] = onClose }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	children.Button = button
	local v21

	if v8 then
		v21 = createElement(Box, {
			color = mapLerp2,
			circular = true,
			size = UDim2.new(0, 4, 1, -20),
			position = UDim2.fromScale(1, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	children.Local = v21

	children.RippleEffect = createElement(RippleEffect, { color = colors.white })

	children.Background = createElement(PlayerListBackground, {
		topRounded = props.topRounded or props.active,
		bottomRounded = props.bottomRounded or props.active,
		color = Roact.joinBindings({ backgroundColor = mapLerp, hover = hover }):map(function(p2)
			return p2.backgroundColor:Lerp(colors.white, Number.lerp(0, 0.1, p2.hover))
		end),
		transparency = not role.special and 0.3 or Binding.mapLerp(v5, 0.3, 0),
		size = UDim2.fromScale(1, 1),
		zIndex = -1
	})
	local v20 = {
		Content = createElement(CanvasContainer, v15, children),
		Shadow = 0
	}
	local shadow

	if role.special then
		shadow = createElement(Shadow, {
			transparency = Binding.mapLerp(v5, 1, 0),
			data = shadows.low[8]
		})
	end

	v20.Shadow = shadow
	return createElement(Container, v13, {
		Player = createElement(Container, v14, v20)
	})
end

local v5 = hook(PlayerListPlayer, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	local revealMode

	if p.platform.pointer == PointerType.Mouse then
		revealMode = v.Hover
	else
		revealMode = v.Active
	end

	return { revealMode = revealMode }
end)(v5))