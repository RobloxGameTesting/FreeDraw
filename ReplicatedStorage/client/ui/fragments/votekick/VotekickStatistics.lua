local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)

local createElement = Roact.createElement
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local Time = require(ReplicatedStorage.shared.lib.Time)
local isPro = require(ReplicatedStorage.shared.util.isPro)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local function VotekickStatisticsItem(props)
	return createElement(Container, {
		size = UDim2.new(1, 0, 0, 24),
		layoutOrder = props.layoutOrder
	}, {
		Icon = createElement(Icon, {
			icon = props.icon,
			color = colors.grey[900],
			size = 24,
			layoutOrder = 1
		}),
		Text = createElement(Text, {
			text = props.text,
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 16,
			color = colors.grey[900],
			layoutOrder = 2
		}),
		Layout = createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		})
	})
end

local function VotekickStatistics(props, p)
	local votekick = props.votekick

	local v, v2 = p.useBinding(Vector2.new(0, 0))
	local v3 = Localization.localContext:useLocale(p)

	local v4 = {
		size = v:map(function(p2)
			return UDim2.new(1, 0, 0, p2.Y)
		end),
		layoutOrder = 1
	}

	local v5 = {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
			v2(p2.AbsoluteSize)
		end, {})
	}
	local children = {
		AccountAge = createElement(VotekickStatisticsItem, {
			icon = "calendar",
			text = Localization.String.new("votekick.statistics.accountAge", {
				date = Time.getRelativeString(-(votekick.target.AccountAge * 60 * 60 * 24), v3)
			}),
			layoutOrder = 1
		}),
		TimeSpent = 0,
		Pro = 0,
		Layout = 0,
		Padding = 0
	}
	local timeSpent

	if not props.hideTime then
		timeSpent = createElement(VotekickStatisticsItem, {
			icon = "clock",
			text = Localization.String.new("votekick.statistics.timeSpent", {
				hours = math.floor(votekick.target:GetAttribute("timeSpent") / 3600)
			}),
			layoutOrder = 2
		})
	end

	children.TimeSpent = timeSpent
	local pro

	if isPro(votekick.target) and not props.hidePro then
		pro = createElement(VotekickStatisticsItem, {
			icon = "pro",
			text = Localization.String.new("votekick.statistics.pro"),
			layoutOrder = 3
		})
	end

	children.Pro = pro

	children.Layout = createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8)
	})

	children.Padding = createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 20),
		PaddingRight = UDim.new(0, 20),
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12)
	})
	return createElement(Container, v4, {
		Content = createElement(Container, v5, children),
		Background = createElement(Box, {
			color = colors.grey[200],
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		}),
		TopLine = createElement(Box, { color = colors.grey[300], size = UDim2.new(1, 0, 0, 1) }),
		BottomLine = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(1, 0, 0, 1),
			position = UDim2.fromScale(0, 1),
			anchorPoint = Vector2.new(0, 1)
		})
	})
end

VotekickStatisticsItem = hook(VotekickStatisticsItem, { componentType = "PureComponent" })
local v = hook(VotekickStatistics, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	local votekick = p.votekick

	local v2 = votekick and p.players[votekick.target.UserId]

	if v2 then
		return { hideRole = v2.hideRole, hideTime = v2.hideTime, hidePro = v2.hidePro }
	end
end)(v))