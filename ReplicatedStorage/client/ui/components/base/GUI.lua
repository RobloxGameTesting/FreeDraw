local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)

local componentPropertyForwarder = createComponentPropertyForwarder({
	zIndex = "DisplayOrder",
	visible = "Enabled"
})

local createElement = Roact.createElement

local function GUI(props)
	return createElement("ScreenGui", componentPropertyForwarder(props, {
		IgnoreGuiInset = not props.inset,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	}), props[Roact.Children])
end

return (hook(GUI, { componentType = "PureComponent" }))