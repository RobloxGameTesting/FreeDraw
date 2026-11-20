local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local IconButton = require(ReplicatedStorage.client.ui.components.button.IconButton)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local TooltipEffect = require(ReplicatedStorage.client.ui.components.effect.TooltipEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local images = require(ReplicatedStorage.client.ui.assets.images)
local layersSlice = require(script.Parent.layersSlice)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local config = require(ReplicatedStorage.shared.data.config)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function LayersCreateButton(props, p)
	local v2 = RoactFlipper.useSpring(p, props.enabled and 1 or 0, v)

	local v3 = {
		size = UDim2.fromOffset(48, 48),
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = props.zIndex
	}
	local children = {
		Icon = createElement(Image, {
			image = images.layers.createLayerButton,
			size = UDim2.fromOffset(18, 18),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Button = createElement(Button, { [Roact.Event.Activated] = props.onClick }),
		TooltipEffect = createElement(TooltipEffect, {
			text = Localization.String.new("layers.toolbar.tooltip.createLayer"),
			direction = Direction.Up
		}),
		RippleEffect = 0,
		HoverTintEffect = 0,
		CursorEffect = 0,
		Background = 0
	}
	local rippleEffect

	if props.enabled then
		rippleEffect = createElement(RippleEffect, { color = colors.white, center = true })
	end

	children.RippleEffect = rippleEffect
	local hoverTintEffect

	if props.enabled then
		hoverTintEffect = createElement(HoverTintEffect, {
			circular = true,
			color = colors.white,
			size = UDim2.fromScale(1, 1)
		})
	end

	children.HoverTintEffect = hoverTintEffect
	local v4

	if props.enabled then
		v4 = CursorType.Pointer
	else
		v4 = CursorType.Default
	end

	children.CursorEffect = createElement(CursorEffect, { type = v4 })

	children.Background = createElement(Box, {
		color = Binding.mapLerp(v2, colors.grey[400], colors.brand),
		circular = true,
		size = UDim2.fromScale(1, 1),
		zIndex = 0
	})
	return createElement(Container, v3, children)
end

local function LayersToolbar(props, p)
	local enabled = props.layer and true or false
	local v2 = props.layerCount == 1
	local v3 = props.layerIndex == 1

	return createElement(
		Container,
		{
			size = props.size,
			position = props.position,
			anchorPoint = props.anchorPoint,
			zIndex = props.zIndex
		},
		{
			Content = createElement(Container, { size = UDim2.fromScale(1, 1), zIndex = 2 }, {
				Icons = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
					Delete = createElement(IconButton, {
						icon = "trash",
						iconSize = 24,
						color = colors.grey[800],
						enabled = enabled and not v2,
						layoutOrder = 1,
						size = UDim2.fromOffset(40, 40),
						onClick = props.onDelete
					}, {
						TooltipEffect = createElement(TooltipEffect, {
							text = Localization.String.new("layers.toolbar.tooltip.deleteLayer"),
							direction = Direction.Up
						})
					}),
					Visible = createElement(IconButton, {
						icon = props.layer and not props.layer.visible and "eyeOff" or "eyeOn",
						iconSize = 24,
						color = colors.grey[800],
						enabled = enabled,
						layoutOrder = 2,
						size = UDim2.fromOffset(40, 40),
						onClick = p.useCallback(function()
							if props.layer then
								props.onSetVisible(not props.layer.visible)
							end
						end, { props.layer })
					}, {
						TooltipEffect = createElement(TooltipEffect, {
							text = Localization.String.new(props.layer and not props.layer.visible and "layers.toolbar.tooltip.hideLayer" or "layers.toolbar.tooltip.showLayer"),
							direction = Direction.Up
						})
					}),
					Merge = createElement(IconButton, {
						icon = "layers",
						iconSize = 24,
						color = colors.grey[800],
						layoutOrder = 3,
						enabled = enabled and not v2 and not v3,
						size = UDim2.fromOffset(40, 40),
						onClick = props.onMerge
					}, {
						TooltipEffect = createElement(TooltipEffect, {
							text = Localization.String.new("layers.toolbar.tooltip.mergeLayer"),
							direction = Direction.Up
						})
					}),
					Layout = createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				}),
				Create = createElement(LayersCreateButton, {
					enabled = props.layerCount < config.layers.limit,
					position = UDim2.new(1, 0, 1, -8),
					anchorPoint = Vector2.new(1, 1),
					zIndex = 2,
					onClick = props.onCreate
				}),
				Padding = createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8)
				})
			}),
			Divider = createElement(Box, {
				color = colors.grey[300],
				size = UDim2.new(1, 0, 0, 1),
				anchorPoint = Vector2.new(0, 1)
			}),
			Background = createElement(Box, {
				color = colors.grey[100],
				radius = 12,
				size = UDim2.fromScale(1, 1),
				position = UDim2.fromScale(0, 1),
				anchorPoint = Vector2.new(0, 1)
			})
		}
	)
end

LayersCreateButton = hook(LayersCreateButton, { componentType = "PureComponent" })
local v2 = hook(LayersToolbar, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onCreate = function(p)
			callback(layersSlice.thunks.createLayerAsync(p))
		end,
		onSetVisible = function(p)
			callback(function(object)
				local state = object:getState()
				object:dispatch(layersSlice.thunks.setLayerVisibleAsync(state.layers.selectedLayer, p))
			end)
		end,
		onMerge = function()
			callback(function(object)
				local state = object:getState()
				object:dispatch(layersSlice.thunks.mergeLayerAsync(state.layers.selectedLayer))
			end)
		end,
		onDelete = function()
			callback(function(object)
				local state = object:getState()
				object:dispatch(layersSlice.thunks.deleteLayerAsync(state.layers.selectedLayer))
			end)
		end
	}
end)(v2))