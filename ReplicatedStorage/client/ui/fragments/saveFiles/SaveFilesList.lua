local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local ScrollContainer = require(ReplicatedStorage.client.ui.components.base.ScrollContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Spinner = require(ReplicatedStorage.client.ui.components.base.Spinner)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local ContextMenuEffect = require(ReplicatedStorage.client.ui.components.effect.ContextMenuEffect)
local TooltipEffect = require(ReplicatedStorage.client.ui.components.effect.TooltipEffect)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Time = require(ReplicatedStorage.shared.lib.Time)
local IconButton = require(ReplicatedStorage.client.ui.components.button.IconButton)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local SaveFilesListNavbar = require(script.Parent.SaveFilesListNavbar)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local toastsSlice = require(ReplicatedStorage.client.ui.fragments.toasts.toastsSlice)
local versionHistorySlice = require(ReplicatedStorage.client.ui.fragments.versionHistory.versionHistorySlice)
local saveFilesSlice = require(script.Parent.saveFilesSlice)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local v = { frequency = 7, dampingRatio = 1 }

local function SaveFile(props, p)
	local v2 = RoactFlipper.useSpring(p, props.selected and 1 or 0, v)

	local v3 = Localization.localContext:useLocale(p)

	local v4 = { size = UDim2.new(1, 0, 0, 72), layoutOrder = props.layoutOrder }
	local children = {
		Content = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
			Name = createElement(Text, {
				text = props.name,
				font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
				fontSize = 22,
				textColor = colors.grey[900],
				layoutOrder = 1
			}),
			Timestamp = createElement(Text, {
				text = Time.useRelativeString(p, props.updatedAt.UnixTimestamp - os.time(), v3),
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				fontSize = 16,
				textColor = colors.grey[400],
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			Padding = createElement("UIPadding", { PaddingLeft = UDim.new(0, 20) })
		}),
		LegacyButton = 0,
		Button = 0,
		Background = 0,
		ContextMenuEffect = 0,
		HoverTintEffect = 0,
		RippleEffect = 0
	}
	local legacyButton

	if props.legacy then
		legacyButton = createElement(IconButton, {
			icon = "alert",
			iconSize = 24,
			color = colors.grey[900],
			size = UDim2.fromOffset(40, 40),
			position = UDim2.new(1, -16, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			zIndex = 10,
			onClick = props.onLegacyInfo
		}, {
			TooltipEffect = createElement(TooltipEffect, {
				text = Localization.String.new("saveFiles.list.tooltip.legacyInfo"),
				direction = Direction.Left
			})
		})
	end

	children.LegacyButton = legacyButton

	children.Button = createElement(Button, {
		[Roact.Event.Activated] = p.useCallback(function()
			props.onSelect(props.id)
		end, {})
	}, {
		CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
	})

	children.Background = createElement(Box, {
		radius = 8,
		borderColor = Binding.mapLerp(v2, colors.grey[300], colors.brand),
		borderThickness = Binding.mapLerp(v2, 1, 2):map(math.round),
		size = Binding.mapLerp(v2, UDim2.new(1, -2, 1, -2), UDim2.new(1, -4, 1, -4)),
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		zIndex = 0
	})

	children.ContextMenuEffect = createElement(ContextMenuEffect, {
		groups = p.useMemo(function()
			return {
				{
					{
						id = "load",
						text = Localization.String.new("saveFiles.list.contextMenu.load"),
						onClick = function()
							props.onLoad(props.id)
						end
					},
					{
						id = "save",
						text = Localization.String.new("saveFiles.list.contextMenu.save"),
						enabled = not props.legacy,
						onClick = function()
							props.onSave(props.id)
						end
					},
					{
						id = "rename",
						text = Localization.String.new("saveFiles.list.contextMenu.rename"),
						onClick = function()
							props.onRename(props.id)
						end
					},
					{
						id = "versionHistory",
						text = Localization.String.new("saveFiles.list.contextMenu.versionHistory"),
						enabled = not props.legacy,
						onClick = function()
							props.onVersionHistory(props.id)
						end
					}
				},
				{
					{
						id = "delete",
						text = Localization.String.new("saveFiles.list.contextMenu.delete"),
						color = colors.red[600],
						onClick = function()
							props.onDelete(props.id)
						end
					}
				}
			}
		end, { v3, props.id, props.legacy, props.onLoad, props.onSave, props.onDelete })
	})

	children.HoverTintEffect = createElement(HoverTintEffect, {
		color = colors.grey[400],
		radius = 8
	})

	children.RippleEffect = createElement(RippleEffect, { color = colors.grey[400], radius = 8 })
	return createElement(Container, v4, children)
end

local function SaveFilesList(props, p)
	local v2, v3 = p.useBinding(Vector2.new(0, 0))

	if not props.loaded then
		return createElement(Container, { size = props.size, layoutOrder = props.layoutOrder }, {
			Spinner = createElement(Spinner, {
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end

	local sorted = Sift.List.sort(props.saveFiles, function(p2, p3): boolean
		return p2.updatedAt.UnixTimestamp > p3.updatedAt.UnixTimestamp
	end)

	local children = {}

	for k, v4 in sorted do
		if not props.search or string.find(v4.name, props.search) then
			children[v4.id] = createElement(SaveFile, {
				id = v4.id,
				name = v4.name,
				createdAt = v4.createdAt,
				updatedAt = v4.updatedAt,
				legacy = v4.legacy,
				layoutOrder = k,
				selected = v4.id == props.selectedSaveFile,
				onSelect = props.onSelect,
				onSave = props.onSave,
				onLoad = props.onLoad,
				onRename = props.onRename,
				onVersionHistory = props.onVersionHistory,
				onDelete = props.onDelete,
				onLegacyInfo = props.onLegacyInfo
			})
		end
	end

	return createElement(ScrollContainer, {
		contentSize = v2:map(function(p2)
			return p2.Y
		end),
		scrollBarInset = 20,
		size = props.size,
		layoutOrder = props.layoutOrder,
		clipsDescendants = false
	}, Sift.Dictionary.join(children, {
		Navbar = createElement(SaveFilesListNavbar, { size = UDim2.new(1, 0, 0, 36) }),
		Layout = createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			[Roact.Change.AbsoluteContentSize] = p.useCallback(function(p2)
				v3(p2.AbsoluteContentSize)
			end, {})
		})
	}))
end

SaveFile = hook(SaveFile, { componentType = "PureComponent" })
local v2 = hook(SaveFilesList, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		selectedSaveFile = p.saveFiles.selectedSaveFile,
		saveFiles = p.saveFiles.saveFiles,
		loaded = p.saveFiles.loaded,
		search = p.saveFiles.search
	}
end, function(callback)
	return {
		onSelect = function(p)
			callback(saveFilesSlice.actions.select(p))
		end,
		onLoad = function(p)
			callback(saveFilesSlice.thunks.loadDialog(p))
		end,
		onSave = function(p)
			callback(saveFilesSlice.thunks.overwriteDialog(p))
		end,
		onRename = function(p)
			callback(saveFilesSlice.thunks.renameDialog(p))
		end,
		onDelete = function(p)
			callback(saveFilesSlice.thunks.deleteDialog(p))
		end,
		onVersionHistory = function(id)
			callback(versionHistorySlice.thunks.ensureVersionsAsync(id))
			callback(screensSlice.actions.pushScreen("versionHistory", { id = id }))
		end,
		onLegacyInfo = function()
			callback(toastsSlice.thunks.showToast({
				text = Localization.String.new("saveFiles.toast.legacyInfo"),
				icon = "alert"
			}))
		end
	}
end)(v2))