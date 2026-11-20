local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local Spinner = require(ReplicatedStorage.client.ui.components.base.Spinner)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local images = require(ReplicatedStorage.client.ui.assets.images)
local ContentStatus = require(ReplicatedStorage.shared.enum.ContentStatus)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
require(ReplicatedStorage.shared.lib.Number)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 5, dampingRatio = 1 }
local v2 = { frequency = 5, dampingRatio = 1 }

local v3 = {
	[ContentStatus.Loaded] = "userData.status.loaded",
	[ContentStatus.Error] = "userData.status.error"
}

local v4 = {
	[ContentStatus.Loaded] = images.userData.loaded,
	[ContentStatus.Error] = images.userData.error
}

local createElement = Roact.createElement

local function UserData(props, p)
	local v5, v6 = p.useBinding(Vector2.new(0, 0))
	local v7 = RoactFlipper.useSpring(p, props.status == ContentStatus.Loading and 0 or 1, v)
	local v8 = RoactFlipper.useSpring(p, props.visible and 1 or 0, v2)
	local mapLerp = Binding.mapLerp(v8, 1, 0)

	local v9 = {
		size = v5:map(function(p2)
			return UDim2.fromOffset(p2.X, 52)
		end),
		position = props.position,
		anchorPoint = props.anchorPoint,
		visible = v8:map(function(p2): boolean
			return p2 > 0.025
		end)
	}

	local v10 = { transparency = mapLerp, size = UDim2.fromScale(1, 1) }

	local v11 = {
		size = UDim2.fromScale(0, 1),
		automaticSize = Enum.AutomaticSize.X,
		clipsDescendants = true,
		[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
			v6(p2.AbsoluteSize)
		end, {})
	}

	local v12 = { size = UDim2.fromOffset(24, 24), layoutOrder = 1 }
	local spinner

	if props.status == ContentStatus.Loading then
		spinner = createElement(Spinner)
	end

	local image

	if props.status ~= ContentStatus.Loading then
		image = createElement(Image, {
			image = v4[props.status],
			color = colors.brand,
			size = UDim2.fromOffset(24, 24)
		})
	end

	local children = {
		Icon = createElement(Container, v12, { Spinner = spinner, Image = image }),
		Text = 0,
		Layout = 0,
		Padding = 0
	}
	local text

	if props.status ~= ContentStatus.Loading then
		text = createElement(Text, {
			text = Localization.String.new(v3[props.status]),
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 20,
			color = colors.grey[900],
			layoutOrder = 2
		})
	end

	children.Text = text

	children.Layout = createElement("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 20)
	})

	children.Padding = createElement("UIPadding", {
		PaddingLeft = Binding.mapLerp(v7, 14, 20):map(function(p2)
			return UDim.new(0, p2)
		end),
		PaddingRight = Binding.mapLerp(v7, 14, 20):map(function(p2)
			return UDim.new(0, p2)
		end)
	})
	return createElement(Container, v9, {
		Container = createElement(CanvasContainer, v10, {
			Content = createElement(Container, v11, children),
			Background = createElement(Box, {
				circular = true,
				size = UDim2.fromScale(1, 1),
				zIndex = 0
			})
		}),
		Shadow = createElement(Shadow, { transparency = mapLerp, data = shadows.low[52] }),
		CursorEffect = createElement(CursorEffect),
		Button = createElement(Button)
	})
end

local v5 = hook(UserData, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { status = p.userData.status, visible = p.userData.visible }
end)(v5))