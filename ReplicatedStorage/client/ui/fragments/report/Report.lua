local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Card = require(ReplicatedStorage.client.ui.components.template.Card)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Text2 = require(ReplicatedStorage.client.ui.components.base.Text)
local TextButton = require(ReplicatedStorage.client.ui.components.button.TextButton)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local reportSlice = require(script.Parent.reportSlice)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Camera = require(ReplicatedStorage.shared.lib.Camera)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function Report(props, props2)
	local v, v2 = props2.useBinding(Vector2.new(0, 0))

	local state, setState = props2.useState(Players.LocalPlayer)
	props2.useEffect(function()
		if props.target then
			setState(props.target)
		end
	end, { props.target })

	return createElement(Card, {
		transparency = props.transparency,
		size = props.size or v:map(function(p)
			return UDim2.fromOffset(16 + p.X + 16, 48)
		end),
		position = props.position,
		anchorPoint = props.anchorPoint
	}, {
		Text = createElement(Text2, {
			text = Localization.String.new("report.text", { name = state.Name }),
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 20,
			color = colors.grey[900],
			layoutOrder = 1
		}),
		Buttons = createElement(Text, { automaticSize = Enum.AutomaticSize.XY, layoutOrder = 2 }, {
			Cancel = createElement(TextButton, {
				text = Localization.String.new("report.button.cancel"),
				style = ButtonStyle.Flat,
				layoutOrder = 2,
				onClick = props.onClose
			}),
			Screenshot = createElement(TextButton, {
				text = Localization.String.new("report.button.screenshot"),
				style = ButtonStyle.Filled,
				layoutOrder = 3,
				onClick = props2.useCallback(function()
					Camera.capture(function(p)
						props.onScreenshot(state, p)
					end)
				end, { state })
			}),
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			})
		}),
		Layout = createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16),
			[Roact.Change.AbsoluteContentSize] = props2.useCallback(function(p)
				v2(p.AbsoluteContentSize)
			end, {})
		})
	})
end

local v = hook(Report, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onScreenshot = function(p, p2)
			callback(reportSlice.thunks.confirmReportDialog(p, p2))
		end,
		onClose = function()
			callback(screensSlice.actions.popScreen())
		end
	}
end)(v))