local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)
local NoYield = require(script.Parent.NoYield)

local v = {
	reportReducerError = function(_, _, p)
		error(string.format("Received error: %s\n\n%s", p.message, p.thrownValue))
	end,
	reportUpdateError = function(_, _, _, p)
		error(string.format("Received error: %s\n\n%s", p.message, p.thrownValue))
	end
}

local function tracebackReporter(p)
	return debug.traceback((tostring(p)))
end

local Store = {}

Store._flushEvent = RunService.Heartbeat

Store.__index = Store

function Store.new(reducer, state, list, p)
	assert(typeof(reducer) == "function", "Bad argument #1 to Store.new, expected function.")
	assert(list == nil or typeof(list) == "table", "Bad argument #3 to Store.new, expected nil or table.")

	if list ~= nil then
		for i = 1, #list do
			assert(
				typeof(list[i]) == "function",
				("Expected the middleware ('%s') at index %d to be a function."):format(tostring(list[i]), i)
			)
		end
	end

	local v2 = {}
	v2._errorReporter = p or v
	v2._isDispatching = false
	v2._reducer = reducer
	local v3 = { type = "@@INIT" }

	v2._actionLog = { v3 }
	local success, result = xpcall(function()
		v2._state = reducer(state, v3)
	end, tracebackReporter)

	if not success then
		v2._errorReporter.reportReducerError(state, v3, {
			message = "Caught error in reducer with init",
			thrownValue = result
		})

		v2._state = state
	end

	v2._lastState = v2._state

	v2._mutatedSinceFlush = false
	v2._connections = {}

	v2.changed = Signal.new(v2)

	setmetatable(v2, Store)

	local connection = v2._flushEvent:Connect(function()
		v2:flush()
	end)
	table.insert(v2._connections, connection)

	if not list then
		return v2
	end

	local dispatch = v2.dispatch
	local function fn(...)
		return dispatch(v2, ...)
	end

	for i = #list, 1, -1 do
		fn = list[i](fn, v2)
	end

	function v2.dispatch(_, ...)
		return fn(...)
	end

	return v2
end

function Store:getState()
	if self._isDispatching then
		error(("You may not call store:getState() while the reducer is executing. The reducer (%s) has already received the state as an argument. Pass it down from the top reducer instead of reading it from the store."):format((tostring(self._reducer))))
	end

	return self._state
end

function Store:dispatch(p)
	if typeof(p) ~= "table" then
		error(("Actions must be tables. Use custom middleware for %q actions."):format((typeof(p))), 2)
	end

	if p.type == nil then
		error(
			"Actions may not have an undefined 'type' property. " .. "Have you misspelled a constant? \n" .. tostring(p),
			2
		)
	end

	if self._isDispatching then
		error("Reducers may not dispatch actions.")
	end

	local success, result = pcall(function()
		self._isDispatching = true
		self._state = self._reducer(self._state, p)
		self._mutatedSinceFlush = true
	end)

	self._isDispatching = false

	if not success then
		self._errorReporter.reportReducerError(self._state, p, {
			message = "Caught error in reducer",
			thrownValue = result
		})
	end

	if #self._actionLog == 3 then
		table.remove(self._actionLog, 1)
	end

	table.insert(self._actionLog, p)
end

function Store:destruct()
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end

	self._connections = nil
end

function Store:flush()
	if not self._mutatedSinceFlush then
		return
	end

	self._mutatedSinceFlush = false

	local state = self._state

	local success, result = xpcall(function()
		NoYield(function()
			self.changed:fire(state, self._lastState)
		end)
	end, tracebackReporter)

	if not success then
		self._errorReporter.reportUpdateError(self._lastState, state, self._actionLog, {
			message = "Caught error flushing store updates",
			thrownValue = result
		})
	end

	self._lastState = state
end

return Store