local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Field = require(ReplicatedStorage.client.ui.components.input.Field)

local createElement = Roact.createElement

local function Color(p, p2)
	local upper = p.value:ToHex():upper()

	return createElement(Field, {
		value = upper,
		placeholder = upper,
		filter = p2.useCallback(function(value)
			return value:gsub("%X", ""):upper():sub(1, 6)
		end, {}),
		size = UDim2.fromOffset(80, 32),
		onFinish = p2.useCallback(function(list): boolean
			if #list ~= 6 then
				return false
			end

			p.onUpdate(Color3.fromHex(list))
			return true
		end, { p.onUpdate })
	})
end

return (hook(Color, { componentType = "PureComponent" }))