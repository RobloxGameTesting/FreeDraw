local BaseMotor = require(script.Parent.BaseMotor)

local object = setmetatable({}, BaseMotor)
object.__index = object

function object.new(value, useImplicitConnections)
	assert(value, "Missing argument #1: initialValue")
	assert(typeof(value) == "number", "initialValue must be a number!")

	local self = setmetatable(BaseMotor.new(), object)

	if useImplicitConnections == nil then
		self._useImplicitConnections = true
	else
		self._useImplicitConnections = useImplicitConnections
	end

	self._goal = nil
	self._state = { complete = true, value = value }

	return self
end

function object:step(p)
	if self._state.complete then
		return true
	end

	local state = self._goal:step(self._state, p)

	self._state = state
	self._onStep:fire(state.value)

	if state.complete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._onComplete:fire()
	end

	return state.complete
end

function object:getValue()
	return self._state.value
end

function object:setGoal(goal)
	self._state.complete = false
	self._goal = goal

	self._onStart:fire()

	if self._useImplicitConnections then
		self:start()
	end
end

function object.__tostring(_): string
	return "Motor(Single)"
end

return object