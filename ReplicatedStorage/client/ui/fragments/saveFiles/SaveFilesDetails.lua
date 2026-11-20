local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local TooltipEffect = require(ReplicatedStorage.client.ui.components.effect.TooltipEffect)
local MultiTextButton = require(ReplicatedStorage.client.ui.components.button.MultiTextButton)
local IconButton = require(ReplicatedStorage.client.ui.components.button.IconButton)
local Direction = require(ReplicatedStorage.shared.enum.Direction)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local versionHistorySlice = require(ReplicatedStorage.client.ui.fragments.versionHistory.versionHistorySlice)
local saveFilesSlice = require(script.Parent.saveFilesSlice)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function SaveFilesDetailsField(props, _)
	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = props.layoutOrder
		},
		{
			Label = createElement(Text, {
				text = props.label,
				font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
				fontSize = 16,
				lineHeight = 1.25,
				color = colors.grey[900],
				textXAlignment = Enum.TextXAlignment.Left,
				wrapped = true,
				size = UDim2.fromScale(1, 0),
				layoutOrder = 1
			}),
			Value = createElement(Text, {
				text = props.value,
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				fontSize = 20,
				lineHeight = 1.25,
				color = colors.grey[900],
				textXAlignment = Enum.TextXAlignment.Left,
				wrapped = true,
				size = UDim2.fromScale(1, 0),
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			})
		}
	)
end

local function SaveFilesDetailsFields(p, _)
	local children = {}

	for k, field in p.fields do
		children[field.id] = createElement(SaveFilesDetailsField, {
			label = field.label,
			value = field.value,
			layoutOrder = k
		})
	end

	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = p.layoutOrder
		},
		Sift.Dictionary.join(children, {
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16)
			})
		})
	)
end

local function SaveFilesDetails(props, p)
	local v = Localization.localContext:useLocale(p)

	if not props.saveFile then
		return createElement(
			Container,
			{
				size = props.size,
				position = props.position,
				anchorPoint = props.anchorPoint,
				layoutOrder = props.layoutOrder
			},
			{
				Icon = createElement(Icon, {
					icon = "cursorGesture",
					size = 64,
					color = colors.grey[900],
					layoutOrder = 1
				}),
				Text = createElement(Text, {
					text = Localization.String.new("saveFiles.details.clickPrompt"),
					font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
					fontSize = 22,
					lineHeight = 1.1,
					color = colors.grey[900],
					wrapped = true,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					layoutOrder = 2
				}),
				Layout = createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12)
				})
			}
		)
	end

	local v2 = {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder
	}
	local back

	if props.includesBackButton then
		back = createElement(IconButton, {
			icon = "back",
			iconSize = 24,
			color = colors.grey[900],
			size = UDim2.fromOffset(40, 40),
			layoutOrder = 0,
			onClick = props.onBack
		})
	end

	return createElement(Container, v2, {
		Back = back,
		Name = createElement(Text, {
			text = props.saveFile.name,
			font = Font.new(fonts.Builder, Enum.FontWeight.ExtraBold),
			fontSize = 32,
			textColor = colors.grey[900],
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = 1
		}),
		Fields = createElement(SaveFilesDetailsFields, {
			fields = {
				{
					id = "createdAt",
					label = Localization.String.new("saveFiles.details.label.createdAt"),
					value = props.saveFile.createdAt:FormatLocalTime("lll", v)
				},
				{
					id = "updatedAt",
					label = Localization.String.new("saveFiles.details.label.updatedAt"),
					value = props.saveFile.updatedAt:FormatLocalTime("lll", v)
				}
			},
			layoutOrder = 2
		}),
		Buttons = createElement(MultiTextButton, {
			buttons = {
				{
					id = "load",
					text = Localization.String.new("saveFiles.details.button.load"),
					onClick = function()
						props.onLoad(props.saveFile.id)
					end
				},
				not props.saveFile.legacy and {
					id = "save",
					text = Localization.String.new("saveFiles.details.button.save"),
					onClick = function()
						props.onSave(props.saveFile.id)
					end
				} or nil
			},
			size = UDim2.new(1, 0, 0, 36),
			layoutOrder = 3
		}),
		ExtendedButtons = createElement(Container, {
			size = UDim2.new(1, 0, 0, 40),
			layoutOrder = 4
		}, {
			Rename = createElement(IconButton, {
				icon = "textEntry",
				iconSize = 24,
				color = colors.grey[900],
				size = UDim2.fromOffset(40, 40),
				layoutOrder = 1,
				onClick = function()
					props.onRename(props.saveFile.id)
				end
			}, {
				TooltipEffect = createElement(TooltipEffect, {
					text = Localization.String.new("saveFiles.details.button.tooltip.rename"),
					direction = Direction.Down
				})
			}),
			VersionHistory = createElement(IconButton, {
				icon = "history",
				iconSize = 24,
				color = colors.grey[900],
				enabled = not props.saveFile.legacy,
				size = UDim2.fromOffset(40, 40),
				layoutOrder = 2,
				onClick = function()
					props.onVersionHistory(props.saveFile.id)
				end
			}, {
				TooltipEffect = createElement(TooltipEffect, {
					text = Localization.String.new("saveFiles.details.button.tooltip.versionHistory"),
					direction = Direction.Down
				})
			}),
			Delete = createElement(IconButton, {
				icon = "trash",
				iconSize = 24,
				color = colors.red[600],
				size = UDim2.fromOffset(40, 40),
				layoutOrder = 3,
				onClick = function()
					props.onDelete(props.saveFile.id)
				end
			}, {
				TooltipEffect = createElement(TooltipEffect, {
					text = Localization.String.new("saveFiles.details.button.tooltip.delete"),
					direction = Direction.Down
				})
			}),
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			})
		}),
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		Padding = createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		})
	})
end

SaveFilesDetailsField = hook(SaveFilesDetailsField, { componentType = "PureComponent" })
SaveFilesDetailsFields = hook(SaveFilesDetailsFields, { componentType = "PureComponent" })
local v = hook(SaveFilesDetails, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		saveFile = p.saveFiles.saveFiles[Sift.List.findWhere(p.saveFiles.saveFiles, function(p2): boolean
			return p2.id == p.saveFiles.selectedSaveFile
		end)]
	}
end, function(callback)
	return {
		onBack = function()
			callback(saveFilesSlice.actions.select(nil))
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
		end
	}
end)(v))