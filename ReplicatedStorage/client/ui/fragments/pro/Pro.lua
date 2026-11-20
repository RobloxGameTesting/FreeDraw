local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local ProFeatures = require(script.Parent.ProFeatures)
local ProBuy = require(script.Parent.ProBuy)
local ProStatus = require(script.Parent.ProStatus)
local remotes = require(ReplicatedStorage.shared.remotes)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local setProRecipient = remotes.Client:Get("setProRecipient")

local createElement = Roact.createElement

local function Pro(props, props2)
	local v, v2 = props2.useBinding(Vector2.new(0, 0))

	local state, setState = props2.useState(nil)
	props2.useEffect(function()
		setProRecipient:SendToServer(props.recipient)

		if props.active then
			setState(props.recipient)
		end

		local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
			if player == props.recipient then
				props.popScreen()
			end
		end)
		return function()
			playerRemovingConnection:Disconnect()
		end
	end, { props.recipient, props.active })

	local v3 = {
		size = v:map(function(p)
			if props.width then
				return (UDim2.fromOffset(props.width, p.Y))
			end

			return (UDim2.new(1, 0, 0, p.Y))
		end)
	}

	local v5 = {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		[Roact.Change.AbsoluteSize] = props2.useCallback(function(p)
			v2(p.AbsoluteSize)
		end, {})
	}

	local v6 = { layoutOrder = 1, automaticSize = Enum.AutomaticSize.Y }
	local v7 = {
		Text = createElement(Text, {
			text = Localization.String.new("pro.title"),
			font = Font.new(fonts.Builder, Enum.FontWeight.ExtraBold),
			fontSize = 32,
			color = colors.brand,
			layoutOrder = 1
		}),
		Gift = 0,
		Layout = 0
	}
	local gift

	if state then
		gift = createElement(Text, {
			text = Localization.String.new("pro.gift", { name = state.Name }),
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 16,
			color = colors.brand,
			layoutOrder = 2
		})
	end

	v7.Gift = gift

	v7.Layout = createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8)
	})
	local children = {
		Title = createElement(Container, v6, v7),
		Features = 0,
		Buy = 0,
		Layout = 0,
		Padding = 0
	}
	local features

	if not state then
		features = createElement(ProFeatures, { layoutOrder = 2 })
	end

	children.Features = features

	children.Buy = createElement(ProBuy, { layoutOrder = 3 })

	children.Layout = createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 20)
	})

	children.Padding = createElement("UIPadding", {
		PaddingTop = UDim.new(0, 24),
		PaddingBottom = UDim.new(0, 24),
		PaddingLeft = UDim.new(0, 24),
		PaddingRight = UDim.new(0, 24)
	})
	local v4 = {
		Content = createElement(Container, v5, children),
		Status = 0
	}
	local status

	if not state then
		status = createElement(ProStatus, {
			position = UDim2.new(1, -16, 0, 16),
			anchorPoint = Vector2.new(1, 0)
		})
	end

	v4.Status = status
	return createElement(Container, v3, v4)
end

local v = hook(Pro, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		popScreen = function()
			callback(screensSlice.actions.popScreen())
		end
	}
end)(v))