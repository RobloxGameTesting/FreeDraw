local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local OverlayContainer = require(ReplicatedStorage.client.ui.components.base.OverlayContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Arrow = require(ReplicatedStorage.client.ui.components.base.Arrow)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local Group = require(ReplicatedStorage.shared.lib.Group)
local variablesSlice = require(ReplicatedStorage.client.ui.fragments.variables.variablesSlice)

local v = { frequency = 5, dampingRatio = 1 }

local LocalPlayer = Players.LocalPlayer

local createElement = Roact.createElement

local function PlayerListPopoutItem(props)
	local v2 = { size = UDim2.new(1, 0, 0, 44), layoutOrder = props.index }
	local v3 = {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Icon = createElement(Icon, {
				icon = props.icon,
				size = 24,
				color = colors.white,
				transparency = props.enabled and 0 or 0.25,
				layoutOrder = 1
			}),
			Text = createElement(Text, {
				text = props.text,
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				fontSize = 20,
				color = colors.white,
				transparency = props.enabled and 0 or 0.25,
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			Padding = createElement("UIPadding", { PaddingLeft = UDim.new(0, 12) })
		}),
		Button = 0,
		RippleEffect = 0,
		HoverTintEffect = 0
	}
	local button

	if props.enabled then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	v3.Button = button
	local rippleEffect

	if props.enabled then
		rippleEffect = createElement(RippleEffect, { color = colors.white })
	end

	v3.RippleEffect = rippleEffect
	local hoverTintEffect

	if props.enabled then
		hoverTintEffect = createElement(HoverTintEffect, { color = colors.white })
	end

	v3.HoverTintEffect = hoverTintEffect
	return createElement(Container, v2, v3)
end

local function PlayerListPopoutGroup(props, p)
	local v2, v3 = p.useBinding(Vector2.new(0, 0))

	return createElement(CanvasContainer, {
		transparency = props.transparency,
		radius = 8,
		layoutOrder = props.layoutOrder,
		size = v2:map(function(p2)
			return UDim2.new(1, 0, 0, p2.Y)
		end)
	}, {
		Content = createElement(Container, {
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
				v3(p2.AbsoluteSize)
			end, {})
		}, Sift.Dictionary.join(props[Roact.Children], {
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})),
		Background = createElement(Box, {
			color = colors.black,
			transparency = 0.3,
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		})
	})
end

local function PlayerListPopoutStat(props)
	return createElement(Container, { size = UDim2.fromScale(1, 1), layoutOrder = props.index }, {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Icon = createElement(Icon, {
				icon = props.icon,
				size = 20,
				color = colors.white,
				layoutOrder = 1
			}),
			Value = createElement(Text, {
				text = props.value,
				font = Font.new(fonts.BuilderMono, Enum.FontWeight.Regular),
				fontSize = 16,
				color = colors.white,
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			Padding = createElement("UIPadding", { PaddingLeft = UDim.new(0, 8) })
		}),
		Background = createElement(Box, {
			color = colors.black,
			transparency = 0.3,
			radius = 8,
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		})
	})
end

local function PlayerListPopoutStatGroup(props, _)
	return createElement(
		CanvasContainer,
		{
			transparency = props.transparency,
			layoutOrder = props.layoutOrder,
			size = UDim2.new(1, 0, 0, 36)
		},
		{
			Content = createElement(
				Container,
				{ size = UDim2.fromScale(1, 1) },
				Sift.Dictionary.join(props[Roact.Children], {
					Layout = createElement("UIListLayout", {
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					})
				})
			)
		}
	)
end

local function PlayerListPopout(props, props2)
	local v2, v3 = props2.useBinding(Vector2.new(0, 0))
	local v4, v5 = RoactFlipper.useSpring(props2, props.active and 1 or 0, v)
	local mapLerp = Binding.mapLerp(v4, 1, 0)

	local state, setState = props2.useState(props.active)
	props2.useEffect(function()
		local v6 = props.active
		v5:onStep(function(p)
			local v7 = p > 0.025

			if v7 ~= v6 then
				setState(v7)
				v6 = v7
			end
		end)
	end, {})

	if not state then
		return nil
	end

	local roleTrusted = Group.getRoleTrusted(props.role)

	local v6 = {
		size = v2:map(function(p)
			if props.compact then
				return (UDim2.new(1, 0, 0, p.Y))
			end

			return (UDim2.fromOffset(200, p.Y))
		end),
		position = v4:map(function(p)
			if props.compact then
				return (UDim2.new(1, 0, 1, Number.lerp(0, 8, p)))
			end

			return (UDim2.new(0, Number.lerp(0, -16, p), 0.5, -16))
		end),
		anchorPoint = Vector2.new(1, 0)
	}

	local v7 = {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		[Roact.Change.AbsoluteSize] = props2.useCallback(function(p)
			v3(p.AbsoluteSize)
		end, {})
	}
	local moderation

	if not props.self then
		local v8 = PlayerListPopoutGroup

		local v9 = {
			Votekick = createElement(PlayerListPopoutItem, {
				index = 1,
				text = Localization.String.new("playerList.contextMenu.votekick"),
				icon = "gavel",
				enabled = not roleTrusted,
				onClick = function()
					props.onVotekickClick(props.id)
					props.onClose()
				end
			}),
			Report = 0,
			Visibility = 0
		}
		local report

		if props.canReport then
			report = createElement(PlayerListPopoutItem, {
				index = 2,
				text = Localization.String.new("playerList.contextMenu.report"),
				icon = "alert",
				enabled = not roleTrusted,
				onClick = function()
					props.onReportClick(props.id)
					props.onClose()
				end
			})
		end

		v9.Report = report

		local v10 = PlayerListPopoutItem
		local text

		if props.hidden then
			text = Localization.String.new("playerList.contextMenu.show")
		else
			text = Localization.String.new("playerList.contextMenu.hide")
		end

		v9.Visibility = createElement(v10, {
			index = 3,
			text = text,
			icon = props.hidden and "eyeOff" or "eyeOn",
			onClick = function()
				props.onVisibilityClick(props.id)
				props.onClose()
			end
		})
		moderation = createElement(v8, { transparency = mapLerp, layoutOrder = 1 }, v9)
	end

	local other

	if not props.self then
		other = createElement(PlayerListPopoutGroup, { transparency = mapLerp, layoutOrder = 2 }, {
			GiftPro = createElement(PlayerListPopoutItem, {
				index = 2,
				text = Localization.String.new("playerList.contextMenu.giftPro"),
				icon = "gift",
				onClick = function()
					props.onGiftProClick(props.id)
					props.onClose()
				end
			})
		})
	end

	local v8 = PlayerListPopoutStatGroup

	local v9 = {
		Playtime = createElement(PlayerListPopoutStat, {
			icon = "clockOutline",
			value = props.hideTime and "?" or `{math.floor(props.timeSpent / 3600)}h`,
			index = 1
		}),
		Age = 0
	}

	local v10 = PlayerListPopoutStat
	local v11

	if props.accountAge then
		if props.accountAge < 365 then
			v11 = `{props.accountAge}d`
		else
			v11 = `{math.floor(props.accountAge / 365.25)}y`
		end
	else
		v11 = "?"
	end

	v9.Age = createElement(v10, { icon = "accountClock", value = v11, index = 2 })
	local children = {
		Content = createElement(Container, v7, {
			Moderation = moderation,
			Other = other,
			Stats = createElement(v8, { transparency = mapLerp, layoutOrder = 3 }, v9),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			})
		}),
		Arrow = 0,
		CursorEffect = 0
	}
	local arrow

	if not props.compact then
		arrow = createElement(Arrow, {
			direction = Direction.Right,
			size = 12,
			color = colors.black,
			transparency = Binding.mapLerp(mapLerp, 0.3, 1),
			position = UDim2.new(1, 0, 0, 16),
			zIndex = 0
		})
	end

	children.Arrow = arrow

	children.CursorEffect = createElement(CursorEffect)
	return createElement(OverlayContainer, v6, children)
end

PlayerListPopoutItem = hook(PlayerListPopoutItem, {
	componentType = "PureComponent",
	defaultProps = { enabled = true }
})

PlayerListPopoutGroup = hook(PlayerListPopoutGroup, { componentType = "PureComponent" })
PlayerListPopoutStat = hook(PlayerListPopoutStat, { componentType = "PureComponent" })
PlayerListPopoutStatGroup = hook(PlayerListPopoutStatGroup, { componentType = "PureComponent" })
local v2 = hook(PlayerListPopout, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	local variable = variablesSlice.selectors.selectVariable(p, "reportEnabled")
	local variable2 = variablesSlice.selectors.selectVariable(p, "reportRole")

	return {
		canReport = variable and Group.getRoleRank(p.players[LocalPlayer.UserId].role) >= Group.getRoleRank(variable2)
	}
end)(v2))