local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local PanelType = require(ReplicatedStorage.shared.enum.PanelType)
local Options = require(ReplicatedStorage.client.ui.fragments.options.Options)
local Layers = require(ReplicatedStorage.client.ui.fragments.layers.Layers)
local PopoutCard = require(ReplicatedStorage.client.ui.components.template.PopoutCard)
local panelsSlice = require(script.Parent.panelsSlice)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function Panel(props, p)
	local v2 = RoactFlipper.useSpring(p, props.active and 1 or 0, v)

	return createElement(
		Container,
		{ size = UDim2.fromOffset(40, 40), layoutOrder = props.layoutOrder },
		Sift.Dictionary.join(props[Roact.Children], {
			Button = createElement(Button, {
				size = UDim2.fromScale(2, 2),
				[Roact.Event.Activated] = props.onClick
			}, {
				CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
			}),
			Icon = createElement(Icon, {
				icon = props.icon,
				size = 24,
				color = Binding.mapLerp(v2, colors.grey[900], colors.white),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5)
			}),
			Background = createElement(Box, {
				circular = true,
				color = Binding.mapLerp(v2, colors.white, colors.brand),
				size = UDim2.fromScale(1, 1),
				zIndex = 0
			}),
			Shadow = createElement(Shadow, { data = shadows.low[40] }),
			RippleEffect = createElement(RippleEffect, {
				color = Binding.mapLerp(v2, colors.black, colors.white),
				center = true
			})
		})
	)
end

local function Panels(props, p)
	return createElement(
		Container,
		{
			automaticSize = Enum.AutomaticSize.XY,
			position = props.position,
			anchorPoint = props.anchorPoint
		},
		{
			OptionsPanel = createElement(Panel, {
				icon = "palette",
				active = props.selectedPanel == PanelType.Options,
				layoutOrder = 1,
				onClick = p.useCallback(function()
					props.onSelectPanel(PanelType.Options)
				end, { props.onSelectPanel })
			}, {
				OptionsPopout = createElement(PopoutCard, {
					active = props.selectedPanel == PanelType.Options,
					offset = 20
				}, {
					Options = createElement(Options, { paginated = true, width = 240 })
				})
			}),
			LayersPanel = createElement(Panel, {
				icon = "layers",
				active = props.selectedPanel == PanelType.Layers,
				layoutOrder = 2,
				onClick = p.useCallback(function()
					props.onSelectPanel(PanelType.Layers)
				end, { props.onSelectPanel })
			}, {
				LayersPopout = createElement(PopoutCard, {
					active = props.selectedPanel == PanelType.Layers,
					offset = 20
				}, {
					Layers = createElement(Layers, { size = UDim2.fromOffset(240, 280) })
				})
			}),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16)
			})
		}
	)
end

Panel = hook(Panel, { componentType = "PureComponent" })
local v2 = hook(Panels, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { selectedPanel = p.panels.selectedPanel }
end, function(callback)
	return {
		onSelectPanel = function(p)
			callback(panelsSlice.actions.selectPanel(p))
		end
	}
end)(v2))