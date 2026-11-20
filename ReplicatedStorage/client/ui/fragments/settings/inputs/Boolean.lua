local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local Checkbox = require(ReplicatedStorage.client.ui.components.input.Checkbox)

local createElement = Roact.createElement

local function Boolean(p)
	return createElement(Checkbox, p)
end

return Boolean