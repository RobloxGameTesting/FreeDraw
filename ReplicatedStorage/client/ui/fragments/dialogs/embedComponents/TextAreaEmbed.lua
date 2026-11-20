local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local FilteredTextArea = require(ReplicatedStorage.client.ui.components.input.FilteredTextArea)

local createElement = Roact.createElement

local function TextAreaEmbed(props, p)
	p.useEffect(function()
		props.onState("")
	end, {})

	return createElement(FilteredTextArea, {
		size = UDim2.new(1, 0, 0, 40),
		placeholder = props.options.placeholder,
		layoutOrder = props.layoutOrder,
		onUpdate = props.onState
	})
end

return (hook(TextAreaEmbed, { componentType = "PureComponent" }))