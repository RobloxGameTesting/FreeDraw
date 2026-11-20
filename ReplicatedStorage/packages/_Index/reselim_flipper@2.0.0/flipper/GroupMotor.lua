local BaseMotor = require(script.Parent.BaseMotor)
local SingleMotor = require(script.Parent.SingleMotor)

local isMotor = require(script.Parent.isMotor)

local object = setmetatable({}, BaseMotor)
object.__index = object

local function toMotor(p)
	if isMotor(p) then
		return p
	end

	local typeName = typeof(p)

	if typeName == "number" then
		return SingleMotor.new(p, false)
	elseif typeName == "table" then
		return object.new(p, false)
	end

	error(("Unable to convert %q to motor; type %s is unsupported"):format(p, typeName), 2)
end

function object.new(p, useImplicitConnections)
	assert(p, "Missing argument #1: initialValues")
	assert(typeof(p) == "table", "initialValues must be a table!")
	assert(
		not p.step,
		"initialValues contains disallowed property \"step\". Did you mean to put a table of values here?"
	)

	local object2 = setmetatable(BaseMotor.new(), object)

	if useImplicitConnections == nil then
		object2._useImplicitConnections = true
	else
		object2._useImplicitConnections = useImplicitConnections
	end

	object2._complete = true
	object2._motors = {}

	for k, v in pairs(p) do
		object2._motors[k] = toMotor(v)
	end

	return object2
end

function object:step(p)
	if self._complete then
		return true
	end

	local v = true

	for _, motor in pairs(self._motors) do
		if not motor:step(p) then
			v = false
		end
	end

	self._onStep:fire(self:getValue())

	if not v then
		return v
	end

	if self._useImplicitConnections then
		self:stop()
	end

	self._complete = true
	self._onComplete:fire()

	return v
end

function object:setGoal(p)
	assert(not p.step, "goals contains disallowed property \"step\". Did you mean to put a table of goals here?")

	self._complete = false
	self._onStart:fire()

	for k, v in pairs(p) do
		assert(self._motors[k], ("Unknown motor for key %s"):format(k)):setGoal(v)
	end

	if self._useImplicitConnections then
		self:start()
	end
end

function object:getValue()
	local value = {}

	for k, motor in pairs(self._motors) do
		value[k] = motor:getValue()
	end

	return value
end

function object.__tostring(_): string
	return "Motor(Group)"
end

return object