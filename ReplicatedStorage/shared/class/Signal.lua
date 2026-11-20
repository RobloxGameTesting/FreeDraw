local function merge(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		if v == nil then
			continue
		end

		for k, v2 in v do
			result[k] = v2
		end
	end

	return result
end

local function clone(items)
	local result = {}

	for k, item in items do
		result[k] = item
	end

	return result
end

local class = {}
class.__index = class

function class.new(signal, handler, options)
	return (setmetatable({
		signal = signal,
		connected = true,
		_handler = handler,
		_options = options or {}
	}, class))
end

function class:call(...)
	if self._options.disconnectAfterCall then
		self:disconnect()
	end

	self._handler(...)
end

function class:disconnect()
	if self.connected then
		self.connected = false
		self.signal:_disconnect(self)
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return (setmetatable({ _threads = {}, _connections = {} }, Signal))
end

function Signal:fire(...)
	local threads = {}

	for k, thread in self._threads do
		threads[k] = thread
	end

	local connections = {}

	for k, connection in self._connections do
		connections[k] = connection
	end

	for _, v in threads do
		coroutine.resume(v, ...)
	end

	for _, v in connections do
		v:call(...)
	end
end

function Signal:connect(p, p2)
	local v = class.new(self, p, p2)
	table.insert(self._connections, v)
	return v
end

function Signal:_disconnect(p)
	local index = table.find(self._connections, p)

	if index then
		table.remove(self._connections, index)
	end
end

function Signal:once(p, p2)
	return self:connect(p, merge(p2, { disconnectAfterCall = true }))
end

function Signal:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

return Signal