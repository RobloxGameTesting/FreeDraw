local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local LabelDecoration = require(ReplicatedStorage.client.ui.components.input.decoration.LabelDecoration)
local Slider = require(ReplicatedStorage.client.ui.components.input.Slider)
local transparencySlice = require(script.Parent.Parent.optionSlices.transparencySlice)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function Transparency(props, p)
	return createElement(LabelDecoration, {
		layoutOrder = props.layoutOrder,
		editable = true,
		label = Localization.String.new("options.picker.label.transparency"),
		value = props.value:map(function(p2)
			return math.round(p2 * 100) .. "%"
		end),
		filter = p.useCallback(function(value)
			return value:gsub("[^%d.]", "")
		end, {}),
		onUpdate = p.useCallback(function(p2)
			local v = tonumber(p2)

			if v then
				props.onUpdate((math.clamp(v / 100, 0, 0.95)))
			end
		end, { props.onUpdate })
	}, {
		Slider = createElement(Slider, {
			color = Binding.mapLerp(props.value, colors.brand, colors.grey[200]),
			value = props.value,
			min = 0,
			max = 0.95,
			step = 0.01,
			onUpdate = props.onUpdate
		})
	})
end

local v = hook(Transparency, { componentType = "PureComponent" })

local bindingConverter = Binding.createBindingConverter(v, { "value" })

return (RoactRodux.connect(function(p)
	return { value = p.options.transparency }
end, function(callback)
	return {
		onUpdate = function(p)
			callback(transparencySlice.actions.setTransparency(p))
		end
	}
end)(bindingConverter))