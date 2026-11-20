local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Slider = require(ReplicatedStorage.client.ui.components.input.Slider)
local LabelDecoration = require(ReplicatedStorage.client.ui.components.input.decoration.LabelDecoration)
local eraseSlice = require(script.Parent.eraseSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local Binding = require(ReplicatedStorage.shared.lib.Binding)

local createElement = Roact.createElement

local function EraseOptions(p, p2)
	return createElement(Container, {
		size = UDim2.fromOffset(240, 0),
		automaticSize = Enum.AutomaticSize.Y
	}, {
		Radius = createElement(LabelDecoration, {
			editable = true,
			label = Localization.String.new("toolbox.erase.options.radius.label"),
			value = p.radius:map(function(p3)
				return ("%.2f"):format(p3)
			end),
			filter = p2.useCallback(function(value)
				return value:gsub("[^%d.]", "")
			end, {}),
			onUpdate = p2.useCallback(function(p3)
				local v = tonumber(p3)

				if v then
					p.setRadius((math.clamp(v, 0.2, 3)))
				end
			end, { p.setRadius })
		}, {
			Slider = createElement(Slider, {
				value = p.radius,
				min = 0.2,
				max = 3,
				step = 0.01,
				onUpdate = p.setRadius
			})
		}),
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		Padding = createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
			PaddingTop = UDim.new(0, 16),
			PaddingBottom = UDim.new(0, 16)
		})
	})
end

local v = hook(EraseOptions, { componentType = "PureComponent" })

local bindingConverter = Binding.createBindingConverter(v, { "radius" })

return (RoactRodux.connect(function(p)
	return { radius = p.toolbox.tools[ToolType.Erase].options.radius }
end, function(callback)
	return {
		setRadius = function(radius)
			callback(eraseSlice.actions.setOptions({ radius = radius }))
		end
	}
end)(bindingConverter))