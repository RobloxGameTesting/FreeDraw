local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "configuration")
local debugLog = import.DebugLog
local debugWarn = import.DebugWarn
local import2 = RuntimeLib.import(script, script.Parent.Parent, "internal")
local getRemoteOrThrow = import2.getRemoteOrThrow
local IS_SERVER = import2.IS_SERVER
local waitForRemote = import2.waitForRemote
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local object = setmetatable({}, {
	__tostring = function(): string
		return "ClientAsyncFunction"
	end
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p)
	self.timeout = 10
	self.listeners = {}
	self.instance = getRemoteOrThrow("AsyncRemoteFunction", p)

	assert(not IS_SERVER, "Cannot create a Net.ClientAsyncFunction on the Server!")
end
function object:Wait(p)
	return RuntimeLib.Promise.defer(RuntimeLib.async(function(callback)
		RuntimeLib.await(waitForRemote("AsyncRemoteFunction", p, 60))
		callback(object.new(p))
	end))
end

function object:SetCallTimeout(timeout)
	assert(timeout > 0, "timeout must be a positive number")
	self.timeout = timeout
end
function object.GetCallTimeout(p)
	return p.timeout
end

function object:SetCallback(callback)
	if self.connector then
		self.connector:Disconnect()
		self.connector = nil
	end

	self.connector = self.instance.OnClientEvent:Connect(RuntimeLib.async(function(...)
		local v = { ... }

		local v2 = v[1]
		local v3 = v[2]

		if type(v2) ~= "string" or type(v3) ~= "table" then
			warn("Recieved message without eventId")

			return
		end

		local v4 = callback(unpack(v3))

		if RuntimeLib.Promise.is(v4) then
			v4:andThen(function(p)
				self.instance:FireServer(v2, p)
			end):catch(function(p)
				warn("[rbx-net] Failed to send response to server: " .. p)
			end)
		else
			self.instance:FireServer(v2, v4)
		end
	end))
end
object.CallServerAsync = RuntimeLib.async(function(data, ...)
	local guid = HttpService:GenerateGUID(false)
	local instance = data.instance
	local v = {}

	for k, v2 in pairs({ ... }) do
		v[k] = v2
	end

	instance:FireServer(guid, v)
	return RuntimeLib.Promise.new(function(callback, callback2)
		local now = tick()
		debugLog("Connected CallServerAsync EventId", guid)
		local onClientEventConnection = nil
		onClientEventConnection = data.instance.OnClientEvent:Connect(function(...)
			local v2 = { ... }

			local v3 = v2[1]
			local v4 = v2[2]

			if type(v3) == "string" and v4 ~= nil and v3 == guid then
				debugLog("Disconnected CallServerAsync EventId", v3)
				onClientEventConnection:Disconnect()
				callback(v4)
			end
		end)
		local listeners = data.listeners
		listeners[guid] = { connection = onClientEventConnection, timeout = data.timeout }

		repeat
			RunService.Heartbeat:Wait()
		until not (onClientEventConnection.Connected and tick() < now + data.timeout)

		data.listeners[guid] = nil

		if now <= tick() and onClientEventConnection.Connected then
			debugWarn("(timeout) Disconnected CallServerAsync EventId", guid)
			onClientEventConnection:Disconnect()
			callback2("Request to server timed out after " .. tostring(data.timeout) .. " seconds")
		end
	end)
end)

return { default = object }