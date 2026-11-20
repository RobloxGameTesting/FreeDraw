local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local HoverTintEffect = require(ReplicatedStorage.client.ui.components.effect.HoverTintEffect)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local createElement = Roact.createElement

local function TextArea(props, p)
	local v = p.useMemo(Roact.createRef, {})

	local v2 = {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex,
		clipsDescendants = true
	}

	local v3 = { size = UDim2.fromScale(1, 1) }

	local v4 = {
		input = true,
		text = "",
		["font"] = Font.new(fonts.Builder, Enum.FontWeight.Regular),
		fontSize = 18,
		lineHeight = 1.25,
		placeholderText = props.placeholder,
		placeholderColor = colors.grey[400],
		color = colors.grey[900],
		textXAlignment = Enum.TextXAlignment.Left
	}
	local textYAlignment

	if props.multiLine then
		textYAlignment = Enum.TextYAlignment.Top
	else
		textYAlignment = Enum.TextYAlignment.Center
	end

	v4.textYAlignment = textYAlignment
	v4.wrapped = props.multiLine

	v4.size = UDim2.fromScale(1, 1)

	v4[Roact.Ref] = v

	v4[Roact.Change.Text] = p.useCallback(function(object)
		local v5 = object.Text

		if props.filter then
			local filtered = props.filter(v5)

			if v5 ~= filtered then
				object.Text = filtered
				v5 = filtered
			end
		end

		if object:IsFocused() and v5 ~= props.value and props.onUpdate then
			props.onUpdate(v5)
		end
	end, { props.onUpdate, props.filter, props.value })
	local children = { Text = createElement(Text, v4), Padding = 0 }

	local v5 = {
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		PaddingTop = 0,
		PaddingBottom = 0
	}
	local paddingTop

	if props.multiLine then
		paddingTop = UDim.new(0, 10)
	end

	v5.PaddingTop = paddingTop
	local paddingBottom

	if props.multiLine then
		paddingBottom = UDim.new(0, 14)
	end

	v5.PaddingBottom = paddingBottom
	children.Padding = createElement("UIPadding", v5)
	return createElement(Container, v2, {
		TextContainer = createElement(Container, v3, children),
		HoverTintEffect = createElement(HoverTintEffect, { color = colors.grey[400] }),
		Button = createElement(Button, {
			zIndex = 0,
			[Roact.Event.Activated] = p.useCallback(function()
				v.current:CaptureFocus()
			end, {})
		}, {
			CursorEffect = createElement(CursorEffect, { type = CursorType.Text })
		}),
		Background = createElement(Box, {
			radius = 8,
			color = colors.grey[200],
			size = UDim2.fromScale(1, 1),
			zIndex = 0
		})
	})
end

return (hook(TextArea, { componentType = "PureComponent" }))