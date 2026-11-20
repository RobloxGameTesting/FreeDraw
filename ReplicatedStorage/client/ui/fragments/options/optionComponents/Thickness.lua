local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local LabelDecoration = require(ReplicatedStorage.client.ui.components.input.decoration.LabelDecoration)
local Slider = require(ReplicatedStorage.client.ui.components.input.Slider)
local thicknessSlice = require(script.Parent.Parent.optionSlices.thicknessSlice)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement

local function Thickness(props, p)
	return createElement(LabelDecoration, {
		layoutOrder = props.layoutOrder,
		editable = true,
		label = Localization.String.new("options.picker.label.thickness"),
		value = props.value:map(function(p2)
			return ("%.2f"):format(p2)
		end),
		filter = p.useCallback(function(value)
			return value:gsub("[^%d.]", "")
		end, {}),
		onUpdate = p.useCallback(function(p2)
			local v = tonumber(p2)

			if v then
				props.onUpdate((math.clamp(v, 0.05, 2)))
			end
		end, { props.onUpdate })
	}, {
		Slider = createElement(Slider, {
			value = props.value,
			min = 0.05,
			max = 2,
			step = 0.01,
			onUpdate = props.onUpdate
		})
	})
end

local v = hook(Thickness, { componentType = "PureComponent" })

local bindingConverter = Binding.createBindingConverter(v, { "value" })

return (RoactRodux.connect(function(p)
	return { value = p.options.thickness }
end, function(callback)
	return {
		onUpdate = function(p)
			callback(thicknessSlice.actions.setThickness(p))
		end
	}
end)(bindingConverter))