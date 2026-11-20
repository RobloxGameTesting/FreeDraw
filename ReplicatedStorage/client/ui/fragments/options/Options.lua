local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local ScreenSelector = require(ReplicatedStorage.client.ui.components.template.ScreenSelector)
local OptionsPickerPanel = require(script.Parent.OptionsPickerPanel)
local OptionsManualPanel = require(script.Parent.OptionsManualPanel)
local optionsSlice = require(script.Parent.optionsSlice)
local Number = require(ReplicatedStorage.shared.lib.Number)

local v = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement

local function Options(props, p)
	local manual = RoactFlipper.useSpring(p, props.manual and 1 or 0, v)

	local pickerSize, onSize = p.useBinding(Vector2.new(0, 0))
	local manualSize, onSize2 = p.useBinding(Vector2.new(0, 0))

	if props.paginated then
		return createElement(ScreenSelector, {
			index = props.manual and 2 or 1,
			alignment = Enum.VerticalAlignment.Bottom,
			size = Roact.joinBindings({
				manual = manual,
				pickerSize = pickerSize,
				manualSize = manualSize
			}):map(function(data)
				return UDim2.fromOffset(props.width, Number.lerp(data.pickerSize.Y, data.manualSize.Y, data.manual))
			end),
			position = props.position,
			anchorPoint = props.anchorPoint
		}, {
			Picker = createElement(OptionsPickerPanel, {
				layoutOrder = 1,
				onSize = onSize,
				onManual = props.onManual
			}),
			Manual = createElement(OptionsManualPanel, {
				layoutOrder = 2,
				backButton = true,
				onSize = onSize2,
				onBack = props.onManual
			})
		})
	end

	return createElement(Container, {
		size = Roact.joinBindings({
			manual = manual,
			pickerSize = pickerSize,
			manualSize = manualSize
		}):map(function(p2)
			return UDim2.fromOffset(props.width * (p2.manual + 1), p2.pickerSize.Y)
		end)
	}, {
		Picker = createElement(OptionsPickerPanel, {
			manual = props.manual,
			layoutOrder = 1,
			size = UDim2.fromOffset(props.width, 0),
			onSize = onSize,
			onManual = props.onManual
		}),
		Manual = createElement(OptionsManualPanel, {
			layoutOrder = 2,
			size = UDim2.fromOffset(props.width, 0),
			position = UDim2.fromOffset(props.width, 0),
			onSize = onSize2,
			onBack = p.useCallback(function()
				props.setScreen(1)
			end, { props.setScreen })
		})
	})
end

local v2 = hook(Options, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { manual = p.options.manual }
end, function(callback)
	return {
		onManual = function()
			callback(optionsSlice.actions.toggleManual())
		end
	}
end)(v2))