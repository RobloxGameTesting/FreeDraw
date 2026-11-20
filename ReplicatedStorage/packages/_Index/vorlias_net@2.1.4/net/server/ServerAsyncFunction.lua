local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "configuration")
local debugLog = import.DebugLog
local debugWarn = import.DebugWarn
local import2 = RuntimeLib.import(script, script.Parent.Parent, "internal")
local findOrCreateRemote = import2.findOrCreateRemote
local IS_CLIENT = import2.IS_CLIENT
local default = RuntimeLib.import(script, script.Parent, "MiddlewareEvent").default
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local function isEventArgs(list): boolean -- 1 equivalent call inferred from this helper
	if #list < 2 then
		return false
	end

	local item = list[1]
	local item2 = list[2]
	return type(item) == "string" and type(item2) == "table"
end

local object = setmetatable({}, {
	__tostring = function(): string
		return "ServerAsyncFunction"
	end,
	__index = default
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p, p2)
	local v = p2 == nil and {} or p2

	default.constructor(self, v)
	self.timeout = 10
	self.listeners = {}
	self.instance = findOrCreateRemote("AsyncRemoteFunction", p, function(p3)
		self.defaultHook = p3.OnServerEvent:Connect(object.DefaultEventHook)
	end)

	assert(not IS_CLIENT, "Cannot create a NetServerAsyncFunction on the client!")
end
function object.GetInstance(p)
	return p.instance
end

function object:SetCallTimeout(timeout)
	assert(timeout > 0, "timeout must be a positive number")
	self.timeout = timeout
	return self
end

function object.GetCallTimeout(p)
	return p.timeout
end

function object:SetCallback(p)
	local defaultHook = self.defaultHook

	if defaultHook ~= nil then
		defaultHook:Disconnect()
	end

	if self.connector then
		self.connector:Disconnect()
		self.connector = nil
	end

	self.connector = self.instance.OnServerEvent:Connect(RuntimeLib.async(function(player, ...)
		local v = { ... }

		if not isEventArgs(v) then -- inferred equivalent call
			warn("[rbx-net-async] Recieved message without eventId")

			return
		end

		local v2 = v[1]
		local v3 = v[2]
		local v4 = self:_processMiddleware(p)

		if v4 ~= nil then
			v4 = v4(player, unpack(v3))
		end

		if RuntimeLib.Promise.is(v4) then
			v4:andThen(function(p2)
				self.instance:FireClient(player, v2, p2)
			end):catch(function(p2)
				warn("[rbx-net] Failed to send response to client: " .. p2)
			end)
			return
		end

		if v4 == nil then
			warn("[rbx-net-async] " .. self.instance.Name .. " returned undefined")
		end

		self.instance:FireClient(player, v2, v4)
	end))
end
object.CallPlayerAsync = RuntimeLib.async(function(data, player, ...)
	local guid = HttpService:GenerateGUID(false)
	local instance = data.instance
	local v = {}

	for k, v2 in pairs({ ... }) do
		v[k] = v2
	end

	instance:FireClient(player, guid, v)
	return RuntimeLib.Promise.new(function(callback, callback2)
		local now = tick()
		debugLog("Connected CallPlayerAsync EventId", guid)
		local onServerEventConnection = nil
		onServerEventConnection = data.instance.OnServerEvent:Connect(function(_, ...)
			local v2 = { ... }

			local v3 = v2[1]
			local v4 = v2[2]

			if type(v3) == "string" and v4 ~= nil and player == player and v3 == guid then
				debugLog("Disconnected CallPlayerAsync EventId", v3)
				onServerEventConnection:Disconnect()
				callback(v4)
			end
		end)
		local listeners = data.listeners
		listeners[guid] = { connection = onServerEventConnection, timeout = data.timeout }

		repeat
			RunService.Stepped:Wait()
		until not (onServerEventConnection.Connected and tick() < now + data.timeout)

		data.listeners[guid] = nil

		if now <= tick() and onServerEventConnection.Connected then
			debugWarn("(timeout) Disconnected CallPlayerAsync EventId", guid)
			onServerEventConnection:Disconnect()
			callback2("Request to client timed out")
		end
	end)
end)

function object.DefaultEventHook(_, ...)
	local _ = { ... }
end

return { default = object }