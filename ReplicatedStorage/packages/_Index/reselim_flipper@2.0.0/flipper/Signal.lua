local class = {}
class.__index = class

function class.new(signal, handler)
	return (setmetatable({ signal = signal, connected = true, _handler = handler }, class))
end

function class:disconnect()
	if self.connected then
		self.connected = false

		for k, connection in pairs(self.signal._connections) do
			if connection == self then
				table.remove(self.signal._connections, k)
				return
			end
		end
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return (setmetatable({ _connections = {}, _threads = {} }, Signal))
end

function Signal:fire(...)
	for _, connection in pairs(self._connections) do
		connection._handler(...)
	end

	for _, thread in pairs(self._threads) do
		coroutine.resume(thread, ...)
	end

	self._threads = {}
end

function Signal:connect(p)
	local v = class.new(self, p)
	table.insert(self._connections, v)
	return v
end

function Signal:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

return Signal