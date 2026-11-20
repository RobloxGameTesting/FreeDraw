local RuntimeLib = require(script.Parent.TS.RuntimeLib)
local IS_CLIENT = RuntimeLib.import(script, script.Parent, "internal").IS_CLIENT
local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()
local v = {
	ServerThrottleResetTimer = 60,
	EnableDebugMessages = false,
	ServerThrottleMessage = "Request limit exceeded ({limit}) by {player} via {remote}"
}

local Configuration = {}

Configuration.DebugEnabled = false
function Configuration.SetClient(items)
	assert(IS_CLIENT, "Use SetClient on the client!")
	local v2 = {}

	for k, v3 in pairs(v) do
		v2[k] = v3
	end

	for k, item in pairs(items) do
		v2[k] = item
	end

	v = v2
end
function Configuration.Set(items)
	assert(isServer, "Use Set on the server!")
	local v2 = {}

	for k, v3 in pairs(v) do
		v2[k] = v3
	end

	for k, item in pairs(items) do
		v2[k] = item
	end

	v = v2
end
function Configuration.Get()
	return v
end

function Configuration.SetClientConfiguration(p, enableDebugMessages)
	assert(IS_CLIENT, "Use SetConfiguration on the server!")

	if p == "EnableDebugMessages" then
		v.EnableDebugMessages = enableDebugMessages
	end
end

function Configuration.SetConfiguration(p, p2)
	assert(isServer, "Cannot set configuration on client!")
	v[p] = p2
end

function Configuration.GetConfiguration(p)
	return v[p]
end

function Configuration.DebugWarn(...)
	local _ = { ... }
end

function Configuration.DebugLog(...)
	local _ = { ... }
end

return Configuration