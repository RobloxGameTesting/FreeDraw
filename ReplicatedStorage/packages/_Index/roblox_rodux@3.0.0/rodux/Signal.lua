local function immutableAppend(listeners, ...)
	local count = #listeners
	local result = {}

	for i = 1, count do
		result[i] = listeners[i]
	end

	for i = 1, select("#", ...) do
		result[count + i] = select(i, ...)
	end

	return result
end

local function immutableRemoveValue(listeners, p)
	local result = {}

	for i = 1, #listeners do
		if listeners[i] ~= p then
			table.insert(result, listeners[i])
		end
	end

	return result
end

local Signal = {}

Signal.__index = Signal

function Signal.new(store)
	local v = { _listeners = {}, _store = store }

	setmetatable(v, Signal)

	return v
end

function Signal:connect(callback)
	if typeof(callback) ~= "function" then
		error("Expected the listener to be a function.")
	end

	if self._store and self._store._isDispatching then
		error("You may not call store.changed:connect() while the reducer is executing. If you would like to be notified after the store has been updated, subscribe from a component and invoke store:getState() in the callback to access the latest state. ")
	end

	local v = {
		callback = callback,
		disconnected = false,
		connectTraceback = debug.traceback(),
		disconnectTraceback = nil
	}

	self._listeners = immutableAppend(self._listeners, v)

	return {
		disconnect = function()
			if v.disconnected then
				error(("Listener connected at: \n%s\nwas already disconnected at: \n%s\n"):format(
					tostring(v.connectTraceback),
					(tostring(v.disconnectTraceback))
				))
			end

			if self._store and self._store._isDispatching then
				error("You may not unsubscribe from a store listener while the reducer is executing.")
			end

			v.disconnected = true
			v.disconnectTraceback = debug.traceback()
			self._listeners = immutableRemoveValue(self._listeners, v)
		end
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		if not listener.disconnected then
			listener.callback(...)
		end
	end
end

return Signal