local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local PopoutCard = require(ReplicatedStorage.client.ui.components.template.PopoutCard)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local images = require(ReplicatedStorage.client.ui.assets.images)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local cameraSlice = require(ReplicatedStorage.client.ui.fragments.camera.cameraSlice)
local navigationSlice = require(script.Parent.navigationSlice)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local ContentStatus = require(ReplicatedStorage.shared.enum.ContentStatus)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function NavigationPopoutPrimaryButton(props)
	return createElement(
		Container,
		{ size = UDim2.new(1, 0, 0, 56), clipsDescendants = true, layoutOrder = props.layoutOrder },
		{
			Button = createElement(Button, { [Roact.Event.Activated] = props.onClick }),
			Text = createElement(Text, {
				text = props.text,
				font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
				fontSize = 24,
				color = colors.white,
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				zIndex = 2
			}),
			Icon = createElement(Icon, {
				icon = props.icon,
				size = 96,
				color = colors.white,
				transparency = 0.8,
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5)
			}),
			Background = createElement(Box, {
				color = colors.brand,
				size = UDim2.fromScale(1, 1),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				zIndex = 0
			}, {
				HoverTintEffect = createElement(HoverTintEffect, {
					color = colors.white,
					transparency = 0.5,
					radius = 8
				}),
				RippleEffect = createElement(RippleEffect, {
					color = colors.white,
					transparency = 0.5,
					radius = 8
				})
			})
		}
	)
end

local function NavigationPopoutButton(props)
	local v2 = { size = UDim2.new(1, 0, 0, 52), layoutOrder = props.layoutOrder }
	local v3 = {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Icon = createElement(Icon, {
				icon = props.icon,
				size = 32,
				color = colors.grey[900],
				transparency = props.enabled and 0 or 0.5,
				layoutOrder = 1
			}),
			Text = createElement(Text, {
				text = props.text,
				font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
				fontSize = 20,
				color = colors.grey[900],
				transparency = props.enabled and 0 or 0.5,
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16)
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16)
			})
		}),
		Button = 0
	}
	local button

	if props.enabled then
		button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			HoverTintEffect = createElement(HoverTintEffect, {
				color = colors.grey[900],
				transparency = 0.5,
				radius = 8
			}),
			RippleEffect = createElement(RippleEffect, {
				color = colors.grey[900],
				transparency = 0.5,
				radius = 8
			})
		})
	end

	v3.Button = button
	return createElement(Container, v2, v3)
end

local function NavigationPopout(props, p)
	return createElement(PopoutCard, {
		active = props.open,
		direction = Direction.Up,
		zIndex = props.zIndex
	}, {
		Container = createElement(
			Container,
			{ size = UDim2.fromOffset(260, 0), automaticSize = Enum.AutomaticSize.Y },
			{
				StartDrawing = createElement(NavigationPopoutPrimaryButton, {
					text = Localization.String.new("navigation.popout.button.startDrawing"),
					icon = "gesture",
					layoutOrder = 1,
					onClick = props.onNavigateCamera
				}),
				SaveFiles = createElement(NavigationPopoutButton, {
					text = Localization.String.new("navigation.popout.button.saveFiles"),
					icon = "save",
					enabled = props.dataReady,
					layoutOrder = 2,
					onClick = p.useCallback(function()
						props.onNavigateScreen("saveFiles")
					end, { props.onNavigateScreen })
				}),
				Settings = createElement(NavigationPopoutButton, {
					text = Localization.String.new("navigation.popout.button.settings"),
					icon = "cog",
					enabled = props.dataReady,
					layoutOrder = 3,
					onClick = p.useCallback(function()
						props.onNavigateScreen("settings")
					end, { props.onNavigateScreen })
				}),
				Rules = createElement(NavigationPopoutButton, {
					text = Localization.String.new("navigation.popout.button.rules"),
					icon = "list",
					layoutOrder = 4,
					onClick = p.useCallback(function()
						props.onNavigateScreen("rules")
					end, { props.onNavigateScreen })
				}),
				Pro = createElement(NavigationPopoutButton, {
					text = Localization.String.new("navigation.popout.button.pro"),
					icon = "pro",
					layoutOrder = 5,
					onClick = p.useCallback(function()
						props.onNavigateScreen("pro")
					end, { props.onNavigateScreen })
				}),
				Layout = createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			}
		)
	})
end

local function Navigation(props, p)
	local v2 = RoactFlipper.useSpring(p, props.open and 1 or 0, v)

	return createElement(
		Container,
		{
			size = UDim2.fromOffset(72, 72),
			position = props.position,
			anchorPoint = props.anchorPoint
		},
		{
			Popout = createElement(NavigationPopout, {
				open = props.open,
				dataReady = props.dataReady,
				zIndex = 10,
				onNavigateScreen = props.onNavigateScreen,
				onNavigateCamera = props.onNavigateCamera
			}),
			Button = createElement(Button, { [Roact.Event.Activated] = props.onToggleOpen }, {
				CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
			}),
			Icon = createElement(Image, {
				image = images.navigation.icon,
				size = UDim2.fromOffset(36, 36),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				rotation = Binding.mapLerp(v2, 0, 45)
			}),
			HoverTintEffect = createElement(HoverTintEffect, {
				circular = true,
				color = colors.white
			}),
			RippleEffect = createElement(RippleEffect, { center = true, color = colors.white }),
			Background = createElement(Box, {
				circular = true,
				color = colors.brand,
				size = UDim2.fromScale(1, 1),
				zIndex = 0
			}),
			Shadow = createElement(Shadow, { data = shadows.low[72] })
		}
	)
end

NavigationPopoutPrimaryButton = hook(NavigationPopoutPrimaryButton, {
	componentType = "PureComponent"
})
NavigationPopoutButton = hook(NavigationPopoutButton, {
	componentType = "PureComponent",
	defaultProps = { enabled = true }
})

NavigationPopout = hook(NavigationPopout, { componentType = "PureComponent" })
local v2 = hook(Navigation, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		open = p.navigation.open,
		dataReady = p.userData.status == ContentStatus.Loaded
	}
end, function(callback)
	return {
		onToggleOpen = function()
			callback(navigationSlice.actions.toggleOpen())
		end,
		onNavigateScreen = function(p)
			callback(screensSlice.actions.pushScreen(p))
			callback(navigationSlice.actions.setOpen(false))
		end,
		onNavigateCamera = function()
			callback(cameraSlice.actions.toggleEnabled())
			callback(navigationSlice.actions.setOpen(false))
		end
	}
end)(v2))