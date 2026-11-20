local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local createElement = Roact.createElement

local function Field(props, p)
	local state, setState = p.useState(false)

	return createElement(Container, {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder,
		clipsDescendants = true
	}, {
		Text = createElement(Text, {
			input = true,
			text = state and "" or Binding.mapAny(props.value, tostring),
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 18,
			color = colors.grey[900],
			placeholderText = props.placeholder,
			placeholderColor = colors.grey[600],
			size = UDim2.fromScale(1, 1),
			automaticSize = Enum.AutomaticSize.None,
			[Roact.Change.Text] = p.useCallback(function(object)
				local v = object.Text

				if object:IsFocused() then
					if props.filter then
						local filtered = props.filter(v)

						if v ~= filtered then
							object.Text = filtered
							v = filtered
						end
					end

					if v ~= Binding.getValueAny(props.value) and props.onUpdate then
						props.onUpdate(v)
					end
				end
			end, { props.onUpdate, props.filter, props.value }),
			[Roact.Event.Focused] = p.useCallback(function()
				setState(true)
			end, {}),
			[Roact.Event.FocusLost] = p.useCallback(function(p2, p3)
				if props.onFinish and props.onFinish(p2.Text, p3) == false then
					p2.Text = Binding.getValueAny(props.value)
				end

				setState(false)
			end, { props.onFinish, props.value })
		}),
		HoverTintEffect = createElement(HoverTintEffect, {
			radius = 8,
			transparency = props.transparency,
			zIndex = 0
		}),
		CursorEffect = createElement(CursorEffect, { type = CursorType.Text }),
		Background = createElement(Box, {
			radius = 8,
			color = colors.grey[200],
			size = UDim2.fromScale(1, 1),
			zIndex = -1
		})
	})
end

return (hook(Field, { componentType = "PureComponent" }))