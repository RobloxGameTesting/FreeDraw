local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Flipper = require(ReplicatedStorage.packages.Flipper)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local toastsSlice = require(script.Parent.toastsSlice)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local createElement = Roact.createElement

local v = { frequency = 4, dampingRatio = 0.9 }
local v2 = { frequency = 4, dampingRatio = 0.9 }

local function Toast(props, props2)
	local offset = props.offset
	local toast = props.toast

	local v3 = props2.useMemo(Roact.createRef, {})

	local v4 = RoactFlipper.useMotor(props2, 0)
	local v5 = RoactFlipper.useMotor(props2, 0)

	local binding = RoactFlipper.getBinding(v4)
	local binding2 = RoactFlipper.getBinding(v5)
	local v6, v7 = props2.useBinding(Vector2.new(0, 0))

	props2.useEffect(function()
		local y = v3.current.AbsoluteSize.Y
		v5:setGoal(Flipper.Instant.new(-(y + 4)))
		v5:step(0)

		local v8 = v4:onComplete(function()
			if v4:getValue() == 0 then
				props.onDelete()
			end
		end)

		return function()
			v8:disconnect()
		end
	end, {})

	props2.useEffect(function()
		v4:setGoal(Flipper.Spring.new(toast.visible and 1 or 0, v))
		v5:setGoal(Flipper.Spring.new(offset, v2))
	end, { offset, toast.visible })

	local mapLerp = Binding.mapLerp(binding, 1, 0)

	local v8 = {
		size = v6:map(function(p)
			return UDim2.new(1, 0, 0, p.Y)
		end),
		position = binding2:map(function(p)
			return UDim2.fromOffset(0, p)
		end),
		zIndex = toast.visible and 1 or 0,
		[Roact.Ref] = v3
	}
	local children = {
		Container = createElement(CanvasContainer, {
			transparency = mapLerp,
			size = UDim2.fromScale(1, 1)
		}, {
			Content = createElement(Container, {
				size = UDim2.new(1, 0, 1, 0),
				automaticSize = Enum.AutomaticSize.Y,
				[Roact.Change.AbsoluteSize] = props2.useCallback(function(p)
					props.onSizeChange(p.AbsoluteSize)
					v7(p.AbsoluteSize)
				end, { props.onSizeChange })
			}, {
				Icon = createElement(Icon, { icon = toast.options.icon, size = 24 }),
				TextContainer = createElement(
					Container,
					{
						size = UDim2.new(1, -36, 0, 0),
						automaticSize = Enum.AutomaticSize.Y,
						position = UDim2.fromOffset(36, 0)
					},
					{
						Text = createElement(Text, {
							text = toast.options.text,
							font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
							fontSize = 18,
							color = colors.white,
							textXAlignment = Enum.TextXAlignment.Left,
							lineHeight = 1.2,
							wrapped = true,
							size = UDim2.fromScale(1, 0),
							automaticSize = Enum.AutomaticSize.Y
						}),
						Padding = createElement("UIPadding", {
							PaddingTop = UDim.new(0, 4),
							PaddingBottom = UDim.new(0, 4)
						})
					}
				),
				Padding = createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12)
				})
			}),
			RippleEffect = createElement(RippleEffect, { color = colors.white, radius = 8 }),
			HoverTintEffect = createElement(HoverTintEffect, { color = colors.white, radius = 8 }),
			Background = createElement(Box, {
				size = UDim2.fromScale(1, 1),
				color = colors.grey[900],
				radius = 8,
				zIndex = 0
			})
		}),
		Shadow = createElement(Shadow, { transparency = mapLerp, data = shadows.low[8] }),
		Button = 0
	}
	local button

	if toast.visible then
		button = createElement(Button, { [Roact.Event.Activated] = props.onHide }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		})
	end

	children.Button = button
	return createElement(Container, v8, children)
end

local function Toasts(props, p)
	local toasts = props.toasts

	local state, setState = p.useState(Sift.Dictionary.fromArrays(Sift.List.map(toasts, function(p2)
		return p2.id
	end), Sift.List.map(toasts, function()
		return Vector2.new(0, 0)
	end)))
	local total = 0
	local children = {}

	for _, toast in toasts do
		children[toast.id] = createElement(Toast, {
			offset = total,
			toast = toast,
			onHide = function()
				props.onHide(toast.id)
			end,
			onDelete = function()
				props.onDelete(toast.id)
			end,
			onSizeChange = function(p2)
				setState(function(p3)
					return Sift.Dictionary.set(p3, toast.id, p2)
				end)
			end
		})

		if not toast.visible then
			continue
		end

		local v3 = state[toast.id]
		total += (not v3 and 0 or v3.Y) + 4
	end

	return createElement(
		Container,
		{
			size = props.size,
			automaticSize = Enum.AutomaticSize.Y,
			position = props.position,
			anchorPoint = props.anchorPoint
		},
		children
	)
end

Toast = hook(Toast, { componentType = "Component" })
local v3 = hook(Toasts, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { toasts = p.toasts }
end, function(callback)
	return {
		onHide = function(p)
			callback(toastsSlice.actions.hideToast(p))
		end,
		onDelete = function(p)
			callback(toastsSlice.actions.deleteToast(p))
		end
	}
end)(v3))