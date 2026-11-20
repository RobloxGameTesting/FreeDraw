local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local images = require(ReplicatedStorage.client.ui.assets.images)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local TextArea = require(ReplicatedStorage.client.ui.components.input.TextArea)
local saveFilesSlice = require(script.Parent.saveFilesSlice)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function SaveFilesCreate(props, p)
	local v, v2 = p.useBinding(Vector2.new(0, 0))

	return createElement(Container, {
		size = v:map(function(p2)
			return UDim2.new(0, 16 + p2.X + 16, 1, 0)
		end),
		position = props.position,
		anchorPoint = props.anchorPoint
	}, {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Icon = createElement(Image, {
				image = images.saveFiles.createIcon,
				size = UDim2.fromOffset(14, 14),
				layoutOrder = 1
			}),
			Text = createElement(Text, {
				text = Localization.String.new("saveFiles.list.createSaveFile"),
				font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
				fontSize = 18,
				color = colors.white,
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16),
				[Roact.Change.AbsoluteContentSize] = p.useCallback(function(p2)
					v2(p2.AbsoluteContentSize)
					props.onSizeChange(16 + p2.AbsoluteContentSize.X + 16)
				end, {})
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16)
			})
		}),
		Button = createElement(Button, { [Roact.Event.Activated] = props.onClick }, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		}),
		Background = createElement(Box, {
			color = colors.brand,
			size = UDim2.fromScale(1, 1),
			zIndex = 0,
			radius = 8
		}),
		HoverTintEffect = createElement(HoverTintEffect, { color = colors.white, radius = 8 }),
		RippleEffect = createElement(RippleEffect, { color = colors.white, radius = 8 })
	})
end

local function SaveFilesSearch(props)
	return createElement(TextArea, {
		placeholder = Localization.String.new("saveFiles.list.search.placeholder"),
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		onUpdate = props.onSearch
	})
end

local function SaveFilesNavbar(props, p)
	local v, onSizeChange = p.useBinding(0)

	return createElement(Container, { size = props.size }, {
		Search = createElement(SaveFilesSearch, {
			size = v:map(function(p2)
				return UDim2.new(1, -(p2 + 8), 1, 0)
			end),
			onSearch = props.onSearch
		}),
		Create = createElement(SaveFilesCreate, {
			position = UDim2.fromScale(1, 0),
			anchorPoint = Vector2.new(1, 0),
			onClick = props.onCreate,
			onSizeChange = onSizeChange
		})
	})
end

SaveFilesCreate = hook(SaveFilesCreate, { componentType = "PureComponent" })
SaveFilesSearch = hook(SaveFilesSearch, { componentType = "PureComponent" })
local v = hook(SaveFilesNavbar, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onSearch = function(list)
			local setSearch = saveFilesSlice.actions.setSearch

			if not (#list > 0) then
				list = nil
			end

			callback(setSearch(list))
		end,
		onCreate = function()
			callback(saveFilesSlice.thunks.createDialog())
		end
	}
end)(v))