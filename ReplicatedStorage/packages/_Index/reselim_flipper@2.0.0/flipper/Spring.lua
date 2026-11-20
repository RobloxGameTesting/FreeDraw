local Spring = {}
Spring.__index = Spring

function Spring.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")
	local v = options or {}

	return (setmetatable({
		_targetValue = targetValue,
		_frequency = v.frequency or 4,
		_dampingRatio = v.dampingRatio or 1
	}, Spring))
end

function Spring:step(p, p2)
	local dampingRatio = self._dampingRatio
	local v = self._frequency * 2 * 3.141592653589793
	local targetValue = self._targetValue
	local value = p.value
	local velocity = p.velocity or 0

	local v2 = value - targetValue
	local v3 = math.exp(-dampingRatio * v * p2)
	local v4, velocity2

	if dampingRatio == 1 then
		v4 = (v2 * (1 + v * p2) + velocity * p2) * v3 + targetValue
		velocity2 = (velocity * (1 - v * p2) - v2 * (v * v * p2)) * v3
	elseif dampingRatio < 1 then
		local v5 = math.sqrt(1 - dampingRatio * dampingRatio)

		local v6 = math.cos(v * v5 * p2)
		local v7 = math.sin(v * v5 * p2)
		local v8

		if v5 > 0.0001 then
			v8 = v7 / v5
		else
			local v9 = p2 * v
			v8 = v9 + (v9 * v9 * (v5 * v5) * (v5 * v5) / 20 - v5 * v5) * (v9 * v9 * v9) / 6
		end

		local v9

		if v * v5 > 0.0001 then
			v9 = v7 / (v * v5)
		else
			local v10 = v * v5
			v9 = p2 + (p2 * p2 * (v10 * v10) * (v10 * v10) / 20 - v10 * v10) * (p2 * p2 * p2) / 6
		end

		v4 = (v2 * (v6 + dampingRatio * v8) + velocity * v9) * v3 + targetValue
		velocity2 = (velocity * (v6 - v8 * dampingRatio) - v2 * (v8 * v)) * v3
	else
		local v5 = math.sqrt(dampingRatio * dampingRatio - 1)

		local v6 = -v * (dampingRatio - v5)
		local v7 = -v * (dampingRatio + v5)

		local v8 = (velocity - v2 * v6) / (2 * v * v5)
		local v9 = (v2 - v8) * math.exp(v6 * p2)
		local v10 = v8 * math.exp(v7 * p2)

		v4 = v9 + v10 + targetValue
		velocity2 = v9 * v6 + v10 * v7
	end

	local complete

	if math.abs(velocity2) < 0.001 then
		complete = math.abs(v4 - targetValue) < 0.001
	else
		complete = false
	end

	v4 = complete and targetValue or v4
	return { complete = complete, value = v4, velocity = velocity2 }
end

return Spring