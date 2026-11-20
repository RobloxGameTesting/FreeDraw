local Throttle = { counters = {} }

local class = {}
class.__index = class

function class.new()
	return (setmetatable({ counter = {} }, class))
end

function class.Get(p, p2)
	return p.counter[p2.UserId] or 0
end

function class.Increment(p, p2)
	local counter = p.counter
	local v = counter[p2.UserId]

	if counter[p2.UserId] then
		counter[p2.UserId] = v + 1
	else
		counter[p2.UserId] = 1
	end
end

function class.__tostring(_): string
	return "RequestCounter"
end

function class:ClearAll()
	self.counter = {}
end

function Throttle.Get(p, p2)
	local counter = p.counters[p2]

	if counter then
		return counter
	end

	local v = class.new()
	p.counters[p2] = v
	return v
end

function Throttle.Clear(p)
	for _, counter in pairs(p.counters) do
		counter:ClearAll()
	end
end

return Throttle