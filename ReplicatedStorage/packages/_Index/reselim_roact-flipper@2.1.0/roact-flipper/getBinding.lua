local Roact = require(script.Parent.Parent.Roact)
local Flipper = require(script.Parent.Parent.Flipper)

local AssignedBinding = require(script.Parent.AssignedBinding)

local function getBinding(bindingsByAssignedBinding)
	assert(bindingsByAssignedBinding, "Missing argument #1: motor")

	if not Flipper.isMotor(bindingsByAssignedBinding) then
		error("Provided value is not a motor!", 2)
	end

	if bindingsByAssignedBinding[AssignedBinding] then
		return bindingsByAssignedBinding[AssignedBinding]
	end

	local binding, v = Roact.createBinding(bindingsByAssignedBinding:getValue())
	bindingsByAssignedBinding:onStep(v)

	bindingsByAssignedBinding[AssignedBinding] = binding
	return binding
end

return getBinding