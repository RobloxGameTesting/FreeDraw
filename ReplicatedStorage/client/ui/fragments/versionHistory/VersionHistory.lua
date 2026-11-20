local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local ScrollContainer = require(ReplicatedStorage.client.ui.components.base.ScrollContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Spinner = require(ReplicatedStorage.client.ui.components.base.Spinner)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local RippleEffect = require(ReplicatedStorage.client.ui.components.effect.RippleEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local ContextMenuEffect = require(ReplicatedStorage.client.ui.components.effect.ContextMenuEffect)
local TextButton = require(ReplicatedStorage.client.ui.components.button.TextButton)
local Time = require(ReplicatedStorage.shared.lib.Time)
local Number = require(ReplicatedStorage.shared.lib.Number)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local versionHistorySlice = require(script.Parent.versionHistorySlice)
local saveFilesSlice = require(ReplicatedStorage.client.ui.fragments.saveFiles.saveFilesSlice)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local v = { frequency = 5, dampingRatio = 1 }

local createElement = Roact.createElement

local function Version(props, props2)
	local state, setState = props2.useState(false)
	local open = RoactFlipper.useSpring(props2, state and 1 or 0, v)
	local contentSize, v2 = props2.useBinding(Vector2.new(0, 0))

	local onClick = props2.useCallback(function()
		props.onLoad(props.id)
	end, { props.onLoad, props.id })

	local onClick2 = props2.useCallback(function()
		props.onDelete(props.id)
	end, { props.onDelete, props.id })

	local v3 = Localization.localContext:useLocale(props2)

	local v4 = {
		size = Roact.joinBindings({ open = open, contentSize = contentSize }):map(function(p)
			return UDim2.new(1, 0, 0, Number.lerp(48, 12 + p.contentSize.Y + 12, p.open))
		end),
		layoutOrder = props.layoutOrder
	}

	local v5 = { size = UDim2.fromScale(1, 1), zIndex = 10, clipsDescendants = true }

	local v6 = { size = UDim2.new(1, 0, 0, 24) }
	local icon

	if props.latest then
		icon = createElement(Icon, {
			icon = "clock",
			color = colors.grey[900],
			size = 24,
			layoutOrder = 1
		})
	end

	local iconSpacer

	if not props.latest then
		iconSpacer = createElement(Container, { size = UDim2.fromOffset(24, 24), layoutOrder = 1 })
	end

	return createElement(Container, v4, {
		Content = createElement(Container, v5, {
			Details = createElement(Container, v6, {
				Icon = icon,
				IconSpacer = iconSpacer,
				Time = createElement(Text, {
					text = Time.getRelativeString(props.time.UnixTimestamp - os.time(), v3),
					font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
					fontSize = 18,
					color = colors.grey[900],
					layoutOrder = 2
				}),
				Layout = createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12)
				})
			}),
			Buttons = createElement(Container, {
				size = UDim2.new(1, 0, 0, 36),
				visible = open:map(function(p): boolean
					return p > 0
				end)
			}, {
				Load = createElement(TextButton, {
					text = Localization.String.new("versionHistory.list.button.load"),
					style = ButtonStyle.Filled,
					layoutOrder = 1,
					onClick = onClick
				}),
				Delete = createElement(TextButton, {
					text = Localization.String.new("versionHistory.list.button.delete"),
					style = ButtonStyle.Flat,
					enabled = not props.latest,
					layoutOrder = 2,
					onClick = onClick2
				}),
				Layout = createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8)
				})
			}),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12),
				[Roact.Change.AbsoluteContentSize] = props2.useCallback(function(p)
					v2(p.AbsoluteContentSize)
				end, {})
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12)
			})
		}),
		ContextMenuEffect = createElement(ContextMenuEffect, {
			groups = props2.useMemo(function()
				return {
					{
						{
							id = "load",
							text = Localization.String.new("versionHistory.list.contextMenu.load"),
							onClick = onClick
						}
					},
					{
						{
							id = "delete",
							text = Localization.String.new("versionHistory.list.contextMenu.delete"),
							color = colors.red[600],
							enabled = not props.latest,
							onClick = onClick2
						}
					}
				}
			end, { onClick, onClick2, props.latest })
		}),
		HoverTintEffect = createElement(HoverTintEffect, { color = colors.grey[400] }),
		RippleEffect = createElement(RippleEffect, { color = colors.grey[400] }),
		Button = createElement(Button, {
			[Roact.Event.Activated] = function()
				setState(function(p): boolean
					return not p
				end)
			end
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Pointer })
		}),
		Line = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			position = UDim2.fromScale(0, 1),
			anchorPoint = Vector2.new(0, 1)
		})
	})
end

local function VersionHistory(props, p)
	local v2, v3 = p.useBinding(Vector2.new(0, 0))

	local sorted = Sift.List.sort(props.versions, function(p2, p3): boolean
		return p2.time.UnixTimestamp > p3.time.UnixTimestamp
	end)

	local onLoad = p.useCallback(function(p2)
		props.onLoad(props.saveFile.id, p2)
	end, { props.onLoad, props.saveFile })

	local onDelete = p.useCallback(function(p2)
		props.onDelete(props.saveFile.id, p2)
	end, { props.onDelete, props.saveFile })

	local children = {}

	for k, v4 in sorted do
		children[v4.id] = createElement(Version, {
			id = v4.id,
			time = v4.time,
			layoutOrder = k,
			latest = k == 1,
			onLoad = onLoad,
			onDelete = onDelete
		})
	end

	local v4 = { size = props.size }

	local v5 = { size = UDim2.new(1, 0, 0, 80) }

	local v6 = { size = UDim2.fromScale(1, 1) }
	local children3 = {
		Header = createElement(Text, {
			text = Localization.String.new("versionHistory.title"),
			font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
			fontSize = 14,
			color = colors.grey[600],
			layoutOrder = 1
		}),
		Name = 0,
		Layout = 0
	}
	local text

	if props.saveFile then
		text = props.saveFile.name
	end

	children3.Name = createElement(Text, {
		text = text,
		font = Font.new(fonts.Builder, Enum.FontWeight.ExtraBold),
		fontSize = 28,
		color = colors.brand,
		layoutOrder = 2
	})

	children3.Layout = createElement("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4)
	})
	local children2 = {
		Header = createElement(Container, v5, {
			Text = createElement(Container, v6, children3),
			Icon = createElement(Icon, {
				icon = "history",
				color = colors.grey[600],
				size = 48,
				position = UDim2.fromScale(1, 0.5),
				anchorPoint = Vector2.new(1, 0.5)
			}),
			Padding = createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16)
			})
		}),
		Divider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			position = UDim2.fromOffset(0, 80)
		}),
		Content = 0,
		LoadingContent = 0
	}
	local content

	if props.loaded then
		content = createElement(ScrollContainer, {
			contentSize = v2:map(function(p2)
				return p2.Y
			end),
			size = UDim2.new(1, 0, 1, -80),
			position = UDim2.fromScale(0, 1),
			anchorPoint = Vector2.new(0, 1)
		}, Sift.Dictionary.join(children, {
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				[Roact.Change.AbsoluteContentSize] = function(p2)
					v3(p2.AbsoluteContentSize)
				end
			})
		}))
	end

	children2.Content = content
	local loadingContent

	if not props.loaded then
		loadingContent = createElement(
			Container,
			{
				size = UDim2.new(1, 0, 1, -88),
				position = UDim2.fromScale(0, 1),
				anchorPoint = Vector2.new(0, 1)
			},
			{
				Spinner = createElement(Spinner, {
					position = UDim2.fromScale(0.5, 0.5),
					anchorPoint = Vector2.new(0.5, 0.5)
				})
			}
		)
	end

	children2.LoadingContent = loadingContent
	return createElement(Container, v4, children2)
end

Version = hook(Version, { componentType = "PureComponent" })
local v2 = hook(VersionHistory, {
	componentType = "PureComponent",
	defaultProps = { versions = {}, loaded = false, size = UDim2.fromScale(1, 1) }
})

return (RoactRodux.connect(function(p)
	local currentScreen = screensSlice.selectors.selectCurrentScreen(p)

	if currentScreen.name ~= "versionHistory" then
		return
	end

	local id = currentScreen.options.id
	local versions = p.versionHistory[id]
	local saveFiles = p.saveFiles.saveFiles

	return {
		versions = versions,
		loaded = versions and true or false,
		saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p2): boolean
			return p2.id == id
		end)]
	}
end, function(callback)
	return {
		onClose = function()
			callback(screensSlice.actions.popScreen())
		end,
		fetchVersions = function(p)
			callback(versionHistorySlice.thunks.fetchVersionsAsync(p))
		end,
		onLoad = function(p, p2)
			callback(saveFilesSlice.thunks.loadAsync(p, p2))
		end,
		onDelete = function(id, versionId)
			callback(screensSlice.actions.pushScreen("dialog", {
				id = "deleteSaveFileVersion",
				title = Localization.String.new("versionHistory.dialog.deleteSaveFileVersion.title"),
				description = Localization.String.new("versionHistory.dialog.deleteSaveFileVersion.description"),
				buttons = {
					{
						id = "cancel",
						text = Localization.String.new("versionHistory.dialog.deleteSaveFileVersion.button.cancel")
					},
					{
						id = "confirm",
						text = Localization.String.new("versionHistory.dialog.deleteSaveFileVersion.button.delete"),
						style = ButtonStyle.Filled,
						color = colors.red[700]
					}
				},
				context = { id = id, versionId = versionId }
			}))
		end
	}
end)(v2))