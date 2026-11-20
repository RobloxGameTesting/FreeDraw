local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local componentPropertyForwarder = createComponentPropertyForwarder({
	text = "Text",
	font = "FontFace",
	fontSize = "TextSize",
	color = "TextColor3",
	transparency = "TextTransparency",
	lineHeight = "LineHeight",
	textXAlignment = "TextXAlignment",
	textYAlignment = "TextYAlignment",
	richText = "RichText",
	wrapped = "TextWrapped",
	placeholderText = "PlaceholderText",
	placeholderColor = "PlaceholderColor3",
	clearTextOnFocus = "ClearTextOnFocus",
	size = "Size",
	automaticSize = "AutomaticSize",
	sizeConstraint = "SizeConstraint",
	position = "Position",
	anchorPoint = "AnchorPoint",
	rotation = "Rotation",
	zIndex = "ZIndex",
	visible = "Visible",
	layoutOrder = "LayoutOrder"
})

local createElement = Roact.createElement

local function Text(props, p)
	local borderThickness = props.borderThickness or props.borderColor or props.borderTransparency

	local v = Localization.localContext:useProvider(p)
	local v2 = Sift.Dictionary.set(props, "text", Binding.mapAny(props.text, function(p2)
		return v:resolve(p2)
	end))

	if v2.input then
		v2 = Sift.Dictionary.set(v2, "placeholderText", Binding.mapAny(v2.placeholderText, function(p2)
			return v:resolve(p2)
		end))
	end

	local v3 = v2.input and "TextBox" or "TextLabel"
	local v4 = componentPropertyForwarder(v2, { BackgroundTransparency = 1, AutoLocalize = false })

	local join = Sift.Dictionary.join
	local v5 = v2[Roact.Children]
	local border

	if borderThickness then
		border = createElement("UIStroke", {
			Thickness = v2.borderThickness or 1,
			Transparency = v2.borderTransparency or 0,
			Color = v2.borderColor or Color3.new(0, 0, 0)
		})
	end

	local constrain

	if v2.constrain then
		constrain = createElement("UISizeConstraint", { MaxSize = v2.constrain })
	end

	return createElement(v3, v4, join(v5, { border = border, constrain = constrain }))
end

return (hook(Text, {
	componentType = "PureComponent",
	defaultProps = {
		text = "Text",
		font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
		fontSize = 16,
		color = Color3.new(0, 0, 0),
		lineHeight = 1,
		richText = true,
		wrapped = false,
		automaticSize = Enum.AutomaticSize.XY
	}
}))