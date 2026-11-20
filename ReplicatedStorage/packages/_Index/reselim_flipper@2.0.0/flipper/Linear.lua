local Linear = {}
Linear.__index = Linear

function Linear.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")

	return (setmetatable({
		_targetValue = targetValue,
		_velocity = (options or {}).velocity or 1
	}, Linear))
end

function Linear:step(p, p2)
	local value = p.value
	local velocity = self._velocity
	local targetValue = self._targetValue

	local v = p2 * velocity

	local complete = math.abs(targetValue - value) <= v
	local v2 = value + v * (value < targetValue and 1 or -1)

	if complete then
		v2 = self._targetValue
		velocity = 0
	end

	return { complete = complete, value = v2, velocity = velocity }
end

return Linear