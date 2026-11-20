local Workspace = game:GetService("Workspace")

local variablesSlice = require(script.Parent.variablesSlice)

local function variablesController(object)
	local variables = Workspace:WaitForChild("Variables")

	local attributeChangedConnection = variables.AttributeChanged:Connect(function(attributeName)
		object:dispatch(variablesSlice.actions.set(attributeName, variables:GetAttribute(attributeName)))
	end)

	object:dispatch(variablesSlice.actions.sync(variables:GetAttributes()))

	return function()
		attributeChangedConnection:Disconnect()
	end
end

return variablesController