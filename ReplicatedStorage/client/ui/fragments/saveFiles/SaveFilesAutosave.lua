local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local TextButton = require(ReplicatedStorage.client.ui.components.button.TextButton)
local Time = require(ReplicatedStorage.shared.lib.Time)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local saveFilesSlice = require(script.Parent.saveFilesSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function SaveFilesAutosave(props, p)
	local v = Localization.localContext:useLocale(p)
	local saveFile = props.autosave.saveFile

	return createElement(Container, { size = props.size, zIndex = 2 }, {
		Text = createElement(Container, {
			size = UDim2.fromScale(1, 1),
			position = UDim2.fromOffset(20, 0)
		}, {
			Label = createElement(Text, {
				text = Localization.String.new("saveFiles.autosave.title"),
				font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
				textSize = 28,
				color = colors.grey[900],
				layoutOrder = 1
			}),
			Time = createElement(Text, {
				text = Time.useRelativeString(p, saveFile.updatedAt.UnixTimestamp - os.time(), v),
				transparency = 0.3,
				font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
				textSize = 20,
				color = colors.grey[900],
				layoutOrder = 2
			}),
			Layout = createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			})
		}),
		Load = createElement(TextButton, {
			text = Localization.String.new("saveFiles.autosave.button.load"),
			style = ButtonStyle.Flat,
			onClick = props.onLoad,
			position = UDim2.new(1, -6, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5)
		}),
		Background = createElement(Box, {
			color = colors.grey[100],
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		}),
		Divider = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			position = UDim2.fromScale(0, 1),
			anchorPoint = Vector2.new(0, 1)
		})
	})
end

local v = hook(SaveFilesAutosave, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { autosave = p.saveFiles.autosave }
end, function(callback)
	return {
		onLoad = function()
			callback(saveFilesSlice.thunks.loadAutosaveDialog())
		end
	}
end)(v))