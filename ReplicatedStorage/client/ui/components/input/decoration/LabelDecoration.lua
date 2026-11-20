local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)

local createElement = Roact.createElement

local function LabelDecoration(props, p)
	local color

	if props.enabled then
		color = colors.grey[900]
	else
		color = colors.grey[400]
	end

	local state, setState = p.useState(false)

	local enabled = props.editable and props.enabled

	local v = {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = props.zIndex,
		layoutOrder = props.layoutOrder
	}
	local join = Sift.Dictionary.join
	local v2 = props[Roact.Children]
	local v3 = { size = UDim2.new(1, 0, 0, 16), layoutOrder = -1 }
	local label

	if props.label then
		label = createElement(Text, {
			text = props.label,
			font = Font.new(fonts.Builder, Enum.FontWeight.Medium),
			fontSize = 18,
			color = color,
			textXAlignment = Enum.TextXAlignment.Left,
			automaticSize = Enum.AutomaticSize.None,
			size = UDim2.fromScale(1, 1)
		})
	end

	local v4

	if props.value then
		local join2 = Sift.Dictionary.join
		local v5 = {
			text = props.value,
			font = Font.new(fonts.BuilderMono, Enum.FontWeight.Regular),
			fontSize = 18,
			color = color,
			transparency = state and 0 or 0.25,
			textXAlignment = Enum.TextXAlignment.Right,
			automaticSize = Enum.AutomaticSize.None,
			size = UDim2.fromScale(1 / 3, 1),
			position = UDim2.fromScale(1, 0),
			anchorPoint = Vector2.new(1, 0)
		}
		local v6

		if enabled then
			v6 = {
				["text"] = nil,
				["text"] = nil,
				["text"] = nil,
				text = state and "" or Binding.mapAny(props.value, tostring),
				input = true
			}

			v6[Roact.Change.Text] = function(object)
				local v7 = object.Text

				if object:IsFocused() then
					if props.filter then
						local filtered = props.filter(v7)

						if v7 ~= filtered then
							object.Text = filtered
							v7 = filtered
						end
					end

					if v7 ~= Binding.getValueAny(props.value) and props.onUpdate then
						props.onUpdate(v7)
					end
				end
			end

			v6[Roact.Event.Focused] = function()
				setState(true)
			end

			v6[Roact.Event.FocusLost] = function(_)
				setState(false)
			end
		end

		local v7 = join2(v5, v6)
		local cursor

		if enabled then
			cursor = createElement(CursorEffect, { type = CursorType.Text })
		end

		v4 = createElement(Text, v7, { Cursor = cursor })
	end

	return createElement(Container, v, join(v2, {
		Text = createElement(Container, v3, { Label = label, Value = v4 }),
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		})
	}))
end

return (hook(LabelDecoration, {
	componentType = "PureComponent",
	defaultProps = { enabled = true }
}))