local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Dropdown = require(ReplicatedStorage.client.ui.components.input.Dropdown)
local Slider = require(ReplicatedStorage.client.ui.components.input.Slider)
local LabelDecoration = require(ReplicatedStorage.client.ui.components.input.decoration.LabelDecoration)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local StabilizerType = require(ReplicatedStorage.shared.enum.StabilizerType)
local drawSlice = require(script.Parent.drawSlice)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local createElement = Roact.createElement

local function DrawOptions(props, p)
	return createElement(Container, {
		size = UDim2.fromOffset(240, 0),
		automaticSize = Enum.AutomaticSize.Y
	}, {
		StabilizerType = createElement(
			LabelDecoration,
			{
				label = Localization.String.new("toolbox.draw.options.stabilizerType.label"),
				zIndex = -1,
				layoutOrder = 1
			},
			{
				Dropdown = createElement(Dropdown, {
					selection = props.stabilizerType,
					items = p.useMemo(function()
						return {
							{
								id = StabilizerType.None,
								text = Localization.String.new("toolbox.draw.options.stabilizerType.selection.none"),
								icon = "missing"
							},
							{
								id = StabilizerType.Rope,
								text = Localization.String.new("toolbox.draw.options.stabilizerType.selection.rope"),
								icon = "radius"
							},
							{
								id = StabilizerType.Window,
								text = Localization.String.new("toolbox.draw.options.stabilizerType.selection.window"),
								icon = "gesture"
							}
						}
					end, {}),
					onSelect = props.setStabilizerType,
					size = UDim.new(1, 0)
				})
			}
		),
		StabilizerIntensity = createElement(LabelDecoration, {
			enabled = props.stabilizerType ~= StabilizerType.None,
			label = Localization.String.new("toolbox.draw.options.stabilizerIntensity.label"),
			value = ("%d%%"):format(props.stabilizerIntensity * 100),
			layoutOrder = 2
		}, {
			Slider = createElement(Slider, {
				value = props.stabilizerIntensity,
				min = 0,
				max = 1,
				step = 0.01,
				enabled = props.stabilizerType ~= StabilizerType.None,
				onUpdate = props.setStabilizerIntensity
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

local v = hook(DrawOptions, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	local options = p.toolbox.tools[ToolType.Draw].options
	return {
		stabilizerType = options.stabilizerType,
		stabilizerIntensity = options.stabilizerIntensity
	}
end, function(callback)
	return {
		setStabilizerType = function(stabilizerType)
			callback(drawSlice.actions.setOptions({ stabilizerType = stabilizerType }))
		end,
		setStabilizerIntensity = function(stabilizerIntensity)
			callback(drawSlice.actions.setOptions({ stabilizerIntensity = stabilizerIntensity }))
		end
	}
end)(v))