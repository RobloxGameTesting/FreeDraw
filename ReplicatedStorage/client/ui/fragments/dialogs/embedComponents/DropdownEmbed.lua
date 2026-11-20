local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Dropdown = require(ReplicatedStorage.client.ui.components.input.Dropdown)

local createElement = Roact.createElement

local function DropdownEmbed(props, p)
	local state, setState = p.useState(props.options.default)

	return createElement(Dropdown, {
		selection = state,
		items = props.options.items,
		placeholder = props.options.placeholder,
		size = UDim.new(1, 0),
		zIndex = props.layoutOrder,
		layoutOrder = props.layoutOrder,
		onSelect = p.useCallback(function(p2)
			setState(p2)
			props.onState(p2)
		end, { props.setState })
	})
end

return (hook(DropdownEmbed, { componentType = "PureComponent" }))