local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local ScrollContainer = require(ReplicatedStorage.client.ui.components.base.ScrollContainer)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Icon = require(ReplicatedStorage.client.ui.components.base.Icon)
local Spinner = require(ReplicatedStorage.client.ui.components.base.Spinner)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local settings = require(ReplicatedStorage.shared.data.settings)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local settingsSlice = require(script.Parent.settingsSlice)
local settingsLayout = require(script.Parent.settingsLayout)

local createElement = Roact.createElement

local function SettingsSetting(props, p)
	local v, v2 = p.useBinding(Vector2.zero)
	local v3, v4 = p.useBinding(Vector2.zero)

	return createElement(Box, {
		color = colors.grey[100],
		transparency = props.index % 2,
		size = v:map(function(p2)
			return UDim2.new(1, 0, 0, 8 + p2.Y + 8)
		end),
		layoutOrder = props.index
	}, {
		Label = createElement(Text, {
			text = Localization.String.new(`settings.{props.id}`),
			font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
			fontSize = 18,
			color = colors.grey[900],
			position = v:map(function(p2)
				if p2.Y > 48 then
					return UDim2.fromOffset(0, 24)
				end

				return UDim2.fromScale(0, 0.5)
			end),
			anchorPoint = Vector2.new(0, 0.5),
			[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
				v4(p2.AbsoluteSize)
			end, {})
		}),
		InputContainer = createElement(Container, {
			automaticSize = Enum.AutomaticSize.Y,
			size = v3:map(function(p2)
				return UDim2.new(1, -(p2.X + 24), 0, 0)
			end),
			position = UDim2.fromScale(1, 0.5),
			anchorPoint = Vector2.new(1, 0.5),
			[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
				v2(p2.AbsoluteSize)
			end, {})
		}, {
			Input = createElement(props.inputComponent, Sift.Dictionary.join(props.inputOptions, {
				value = props.value,
				onUpdate = p.useCallback(function(p2)
					props.onSetting(props.id, p2)
				end, { props.id, props.onSetting })
			})),
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			})
		}),
		Padding = createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		})
	})
end

local function SettingsCategory(props)
	return createElement(
		Container,
		{
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = props.layoutOrder
		},
		{
			Label = createElement(Container, { size = UDim2.new(1, 0, 0, 36) }, {
				Text = createElement(Text, {
					text = Localization.String.new(`settings.category.{props.id}`),
					font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
					fontSize = 36,
					color = colors.grey[900],
					position = UDim2.fromScale(0, 0.5),
					anchorPoint = Vector2.new(0, 0.5)
				}),
				Icon = createElement(Icon, {
					icon = props.icon,
					size = 36,
					color = colors.grey[900],
					position = UDim2.fromScale(1, 0.5),
					anchorPoint = Vector2.new(1, 0.5)
				}),
				Padding = createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				})
			}),
			Content = createElement(
				Container,
				{
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					layoutOrder = 2
				},
				Sift.Dictionary.join(props[Roact.Children], {
					Layout = createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				})
			),
			Layout = createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			Padding = createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			})
		}
	)
end

local function Settings(props, p)
	local v, v2 = p.useBinding(Vector2.zero)

	if not props.data then
		return createElement(Container, { size = props.size }, {
			Spinner = createElement(Spinner, {
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end

	local children = {}

	for k, v3 in settingsLayout do
		local children2 = {}

		for k2, setting in v3.settings do
			local id = setting.id
			local v4 = props.data[id]

			if v4 == nil then
				v4 = settings[id].default
			end

			children2[id] = createElement(SettingsSetting, {
				index = k2,
				id = id,
				value = v4,
				inputComponent = setting.component,
				inputOptions = setting.options,
				onSetting = props.onSetting
			})
		end

		children[v3.id] = createElement(SettingsCategory, {
			id = v3.id,
			icon = v3.icon,
			layoutOrder = k * 2
		}, children2)
	end

	for i = 1, #settingsLayout - 1 do
		children[`Divider({i})`] = createElement(Box, {
			color = colors.grey[300],
			size = UDim2.new(0.9, 0, 0, 1),
			layoutOrder = i * 2 + 1
		}, {
			Gradient = createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.1, 0),
					NumberSequenceKeypoint.new(0.9, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		})
	end

	return createElement(
		ScrollContainer,
		{ size = props.size, contentSize = Binding.mapPluck(v, "Y") },
		Sift.Dictionary.join(children, {
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				[Roact.Change.AbsoluteContentSize] = p.useCallback(function(p2)
					v2(p2.AbsoluteContentSize)
				end, {})
			})
		})
	)
end

SettingsSetting = hook(SettingsSetting, { componentType = "PureComponent" })
SettingsCategory = hook(SettingsCategory, { componentType = "PureComponent" })
local v = hook(Settings, {
	componentType = "PureComponent",
	defaultProps = { size = UDim2.fromScale(1, 1) }
})

return (RoactRodux.connect(function(p)
	return { data = p.settings }
end, function(callback)
	return {
		onSetting = function(p, p2)
			callback(settingsSlice.actions.set(p, p2))
		end
	}
end)(v))