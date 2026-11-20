local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Flipper = require(ReplicatedStorage.packages.Flipper)
local Sift = require(ReplicatedStorage.packages.Sift)
local enumerator = require(ReplicatedStorage.packages.enumerator)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local ScrollContainer = require(ReplicatedStorage.client.ui.components.base.ScrollContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local ContextMenuEffect = require(ReplicatedStorage.client.ui.components.effect.ContextMenuEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local LayersToolbar = require(script.Parent.LayersToolbar)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local layersSlice = require(script.Parent.layersSlice)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local String = require(ReplicatedStorage.shared.lib.String)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local v = { frequency = 5, dampingRatio = 1 }
local v2 = { frequency = 8, dampingRatio = 1 }
local v3 = { frequency = 8, dampingRatio = 1 }
local v4 = { frequency = 5, dampingRatio = 1 }

local v5 = enumerator("LayerInputMode", { "Click", "Drag", "Scroll" })

local createElement = Roact.createElement

local function Layer(props, props2)
	local state, setState = props2.useState(false)
	local v6 = RoactFlipper.useMotor(props2, props.index)
	local binding = RoactFlipper.getBinding(v6)
	local v7 = props2.useValue(props.index)
	props2.useEffect(function()
		if not state and props.index ~= v7.value then
			v6:setGoal(Flipper.Spring.new(props.index))
		end

		v7.value = props.index
	end, { state, props.index })

	local state2, setState2 = props2.useState(false)
	local v8 = props2.useMemo(Roact.createRef, {})
	local v9 = props2.useMemo(Roact.createRef, {})
	local v10 = props2.useValue(-1e999)
	props2.useEffect(function()
		if state2 and not v9.current:IsFocused() then
			v9.current:CaptureFocus()
		elseif v9.current:IsFocused() then
			v9.current:ReleaseFocus()
		end
	end, { state2 })

	local v11 = RoactFlipper.useSpring(props2, state and 1 or 0, v4)
	local v12 = RoactFlipper.useSpring(props2, props.selected and 1 or 0, v2)
	local transparency = RoactFlipper.useSpring(props2, props.visible and 1 or 0, v3)

	local v13 = props2.useMemo(Roact.createRef, {})
	local function getRelativePosition(y) -- 6 equivalent calls inferred from this helper
		if v13.current then
			return y - v13.current.Parent.AbsolutePosition.Y
		end

		return 0
	end

	local v14 = props.layerCount == 1
	local v15 = props.index == 1

	return createElement(Container, {
		size = UDim2.new(1, 0, 0, 48),
		position = binding:map(function(p)
			return UDim2.new(0, 0, 1, -(p - 1) * 49)
		end),
		anchorPoint = Vector2.new(0, 1),
		zIndex = Binding.mapLerp(v11, 0, 100),
		[Roact.Ref] = v13
	}, {
		Button = createElement(Button, {
			active = false,
			[Roact.Event.InputBegan] = props2.useCallback(function(_, instance)
				local v16 = instance.UserInputType == Enum.UserInputType.MouseButton1
				local v17 = instance.UserInputType == Enum.UserInputType.Touch

				if (v16 or v17) and instance.UserInputState == Enum.UserInputState.Begin then
					local y = instance.Position.Y
					local relativePosition = getRelativePosition(y) -- inferred equivalent call
					local lastTime = os.clock()

					local v18 = props.index

					local v19 = v5.Click

					local function getTargetIndex() -- 1 equivalent call inferred from this helper
						local v20 = v18
						local v21

						if props.index < v20 then
							v21 = math.floor(v20)
						else
							v21 = math.ceil(v20)
						end

						return (math.clamp(v21, 1, props.layerCount))
					end

					local function dragMove(p) -- 3 equivalent calls inferred from this helper
						v18 = props.index - (p - relativePosition) / 49
						v6:setGoal(Flipper.Instant.new(v18))
					end

					local function dragStart(p) -- 2 equivalent calls inferred from this helper
						v19 = v5.Drag
						setState(true)
						props.onDrag(true)
						dragMove(p) -- inferred equivalent call
					end

					local function dragEnd()
						local targetIndex = getTargetIndex() -- inferred equivalent call

						if targetIndex == props.index then
							v6:setGoal(Flipper.Spring.new(props.index, v))
						else
							props.onMove(props.id, targetIndex)
						end

						setState(false)
						props.onDrag(false)
					end

					local v20 = Maid.new()

					if v16 then
						v20:giveTask(UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement then
								if v19 == v5.Drag then
									dragMove(getRelativePosition(input.Position.Y)) -- inferred equivalent call
								elseif math.abs(getRelativePosition(input.Position.Y) - relativePosition) > 5 then -- inferred equivalent call
									dragStart(getRelativePosition(input.Position.Y)) -- inferred equivalent call
								end
							end
						end))
					elseif v17 then
						local v21

						if v17 then
							v21 = instance:GetPropertyChangedSignal("Position"):Connect(function()
								if v19 == v5.Drag then
									dragMove(getRelativePosition(instance.Position.Y)) -- inferred equivalent call
								end
							end)
						end

						v20:giveTask(v21)
						local v22

						if v17 then
							v22 = RunService.Heartbeat:Connect(function()
								if v19 ~= v5.Drag then
									if os.clock() - lastTime > 0.3 then
										dragStart(getRelativePosition(instance.Position.Y)) -- inferred equivalent call
									elseif math.abs(instance.Position.Y - y) > 5 then
										v19 = v5.Scroll
										v20:clean()
									end
								end
							end)
						end

						v20:giveTask(v22)
					end

					v20:giveTask(instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if instance.UserInputState == Enum.UserInputState.End then
							if v19 == v5.Drag then
								dragEnd()
							elseif v19 == v5.Click then
								if os.clock() - v10.value < 0.3 then
									setState2(true)
								else
									props.onSelect(props.id)
								end

								v10.value = os.clock()
							end

							v20:clean()
						end
					end))
				end
			end, {
				props.onSelect,
				props.onMove,
				props.onDrag,
				props.index,
				props.id,
				props.layerCount
			})
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		}),
		Name = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Name = createElement(Text, {
				text = props.name,
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				fontSize = 20,
				color = colors.grey[900],
				textXAlignment = Enum.TextXAlignment.Left,
				automaticSize = Enum.AutomaticSize.None,
				size = UDim2.fromScale(1, 1),
				visible = not state2,
				[Roact.Ref] = v8
			}),
			NameEditable = createElement(Text, {
				text = "",
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				fontSize = 20,
				color = colors.grey[900],
				placeholderText = props.name,
				placeholderColor = colors.grey[500],
				textXAlignment = Enum.TextXAlignment.Left,
				input = true,
				automaticSize = Enum.AutomaticSize.None,
				size = UDim2.fromScale(1, 1),
				visible = state2,
				[Roact.Ref] = v9,
				[Roact.Event.FocusLost] = props2.useCallback(function(p)
					local trimmed = String.trim(p.Text)

					if #trimmed > 0 then
						props.onRename(props.id, trimmed)
						v8.current.Text = trimmed
					else
						p.Text = ""
					end

					setState2(false)
				end, { props.onRename, props.name })
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16)
			})
		}),
		Hidden = createElement(Icon, {
			icon = "eyeOff",
			size = 24,
			color = colors.grey[500],
			transparency = transparency,
			position = UDim2.new(1, -16, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5)
		}),
		ContextMenuEffect = createElement(ContextMenuEffect, {
			groups = props2.useMemo(function()
				return {
					{
						{
							id = "rename",
							text = Localization.String.new("layers.list.contextMenu.rename"),
							onClick = function()
								setState2(true)
							end
						},
						{
							id = "visibility",
							text = Localization.String.new(props.visible and "layers.list.contextMenu.hide" or "layers.list.contextMenu.show"),
							onClick = function()
								props.onSetVisible(props.id, not props.visible)
							end
						},
						{
							id = "merge",
							text = Localization.String.new("layers.list.contextMenu.merge"),
							enabled = not (v14 or v15),
							onClick = function()
								props.onMerge(props.id)
							end
						}
					},
					{
						{
							id = "delete",
							text = Localization.String.new("layers.list.contextMenu.delete"),
							enabled = not v14,
							color = colors.red[600],
							onClick = function()
								props.onDelete(props.id)
							end
						}
					}
				}
			end, { props.onSetVisible, props.onDelete, props.visible, v14, v15 })
		}),
		TopDivider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			anchorPoint = Vector2.new(0, 1)
		}),
		BottomDivider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			position = UDim2.fromScale(0, 1)
		}),
		HighlightBackground = createElement(
			Box,
			{
				color = colors.brand,
				transparency = Binding.mapLerp(v12, 1, 0.95),
				size = UDim2.fromScale(1, 1),
				zIndex = 0
			},
			{
				Highlight = createElement(Box, {
					color = colors.brand,
					transparency = Binding.mapLerp(v12, 1, 0),
					size = UDim2.new(0, 3, 1, 0)
				})
			}
		),
		Background = createElement(Box, {
			color = Binding.mapLerp(transparency, colors.grey[200], colors.white),
			size = UDim2.fromScale(1, 1),
			zIndex = -1
		})
	})
end

local function Layers(props, p)
	local v6 = RoactFlipper.useSpring(p, #props.layers, v)
	local state, setState = p.useState(false)

	local where = Sift.List.findWhere(props.layers, function(p2)
		if p2 then
			return p2.id == props.selectedLayer
		end
	end)
	local layer = props.layers[where]

	local children = {}

	for k, layer2 in props.layers do
		children[layer2.id] = createElement(Layer, {
			index = k,
			layerCount = #props.layers,
			name = layer2.name,
			visible = layer2.visible,
			id = layer2.id,
			selected = props.selectedLayer == layer2.id,
			onDrag = setState,
			onSelect = props.onSelect,
			onMove = props.onMove,
			onSetVisible = props.onSetVisible,
			onRename = props.onRename,
			onMerge = props.onMerge,
			onDelete = props.onDelete
		})
	end

	return createElement(
		Container,
		{
			size = props.size,
			position = props.position,
			anchorPoint = props.anchorPoint,
			layoutOrder = props.layoutOrder
		},
		{
			List = createElement(ScrollContainer, {
				active = false,
				dragEnabled = not state,
				contentSize = v6:map(function(p2)
					return p2 * 49 - 1
				end),
				size = UDim2.new(1, 0, 1, -40)
			}, {
				Content = createElement(Container, {
					size = v6:map(function(p2)
						return UDim2.new(1, 0, 0, p2 * 49 - 1)
					end)
				}, children)
			}),
			Toolbar = createElement(LayersToolbar, {
				layer = layer,
				layerIndex = where,
				layerCount = #props.layers,
				size = UDim2.new(1, 0, 0, 40),
				position = UDim2.fromScale(0, 1),
				anchorPoint = Vector2.new(0, 1),
				zIndex = 10
			})
		}
	)
end

Layer = hook(Layer, { componentType = "PureComponent" })
local v6 = hook(Layers, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return p.layers
end, function(callback)
	return {
		onSelect = function(p)
			callback(layersSlice.actions.selectLayer(p))
		end,
		onMove = function(p, p2)
			callback(layersSlice.thunks.moveLayerAsync(p, p2))
		end,
		onSetVisible = function(p, p2)
			callback(layersSlice.thunks.setLayerVisibleAsync(p, p2))
		end,
		onRename = function(p, p2)
			callback(layersSlice.thunks.renameLayerAsync(p, p2))
		end,
		onMerge = function(p)
			callback(layersSlice.thunks.mergeLayerAsync(p))
		end,
		onDelete = function(p)
			callback(layersSlice.thunks.deleteLayerAsync(p))
		end
	}
end)(v6))