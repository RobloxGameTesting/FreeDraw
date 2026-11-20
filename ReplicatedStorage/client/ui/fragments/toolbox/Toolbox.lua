local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local toolboxSlice = require(script.Parent.toolboxSlice)
local Tool = require(script.Parent.Tool)
local tools = require(script.Parent.tools)

local LocalPlayer = Players.LocalPlayer
local createElement = Roact.createElement

local udim = UDim.new(0, 20)
local v = { ToolType.Draw, ToolType.Line, ToolType.Erase, ToolType.Claim, ToolType.Shape }

local function ToolboxActions(props)
	local children = {}

	for _, v2 in v do
		local tool = tools[v2]

		if tool.actionsComponent then
			children[`{tool.type.name}`] = createElement(tool.actionsComponent, {
				active = props.selectedTool == tool.type
			})
		end
	end

	return createElement(
		Container,
		{
			size = UDim2.fromOffset(0, props.size),
			position = props.position,
			anchorPoint = props.anchorPoint,
			zIndex = props.zIndex
		},
		children
	)
end

local function Toolbox(props, p)
	local v2, v3 = p.useBinding(Vector2.new(0, 0))

	local mapped = Sift.List.map(v, function(p2)
		local tool = tools[p2]

		if tool.pro and not props.pro then
			return nil
		end

		return createElement(Tool, {
			type = tool.type,
			active = tool.type == props.selectedTool,
			keys = tool.keys,
			icon = tool.icon,
			optionsComponent = tool.optionsComponent,
			onSelect = props.onSelectTool
		})
	end)

	return createElement(Container, {
		size = v2:map(function(p2)
			return UDim2.fromOffset(8 + p2.X + 8, 64) + UDim2.new(udim + udim, udim + udim)
		end),
		position = props.position,
		anchorPoint = props.anchorPoint
	}, {
		Actions = createElement(ToolboxActions, {
			transparency = props.transparency,
			selectedTool = props.selectedTool,
			size = 48,
			position = UDim2.new(0.5, 0, 0, -20),
			anchorPoint = Vector2.new(0.5, 1)
		}),
		Toolbox = createElement(
			CanvasContainer,
			{
				transparency = props.transparency,
				size = UDim2.fromScale(1, 1),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5)
			},
			{
				Content = createElement(
					Container,
					{ size = UDim2.fromScale(1, 1), zIndex = 2 },
					Sift.Dictionary.join(mapped, {
						Layout = createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							[Roact.Change.AbsoluteContentSize] = p.useCallback(function(p2)
								v3(p2.AbsoluteContentSize)
							end, {})
						}),
						Padding = createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 8),
							PaddingRight = UDim.new(0, 8)
						})
					})
				),
				Box = createElement(Box, {
					size = UDim2.fromScale(1, 1),
					circular = true,
					zIndex = 0
				}),
				Shadow = createElement(Shadow, { data = shadows.low[64] }),
				CursorEffect = createElement(CursorEffect),
				Padding = createElement("UIPadding", {
					PaddingLeft = udim,
					PaddingRight = udim,
					PaddingTop = udim,
					PaddingBottom = udim
				})
			}
		)
	})
end

ToolboxActions = hook(ToolboxActions, { componentType = "PureComponent" })
local v2 = hook(Toolbox, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		pro = p.players[LocalPlayer.UserId].proExpiry > os.time(),
		selectedTool = p.toolbox.selectedTool
	}
end, function(callback)
	return {
		onSelectTool = function(p)
			callback(toolboxSlice.actions.setTool(p))
		end
	}
end)(v2))