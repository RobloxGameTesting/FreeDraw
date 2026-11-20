local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "internal")
local format = import.format
local IS_SERVER = import.IS_SERVER
local serverTickFunctions = import.ServerTickFunctions
local import2 = RuntimeLib.import(script, script, "throttle")
local getConfiguration = RuntimeLib.import(script, script.Parent.Parent, "configuration").GetConfiguration
local v = {}
local function rateLimitWarningHandler(p)
	warn("[rbx-net]", p.Message)
end

local function createRateLimiter(p)
	local maxRequestsPerMinute = p.MaxRequestsPerMinute
	local v2 = p.ErrorHandler

	if v2 == nil then
		v2 = rateLimitWarningHandler
	end

	return function(callback, object)
		local instance = object:GetInstance()
		local v3 = v[object]

		if v3 == nil then
			v3 = import2:Get(instance:GetFullName())
		end

		return function(p2, ...)
			local v4 = { ... }

			if not (maxRequestsPerMinute <= v3:Get(p2)) then
				v3:Increment(p2)
				return callback(p2, unpack(v4))
			end

			local v5 = v2

			if v5 == nil then
				return
			end

			v5({
				Message = format(getConfiguration("ServerThrottleMessage"), {
					player = p2.UserId,
					remote = instance.Name,
					limit = maxRequestsPerMinute
				}),
				MaxRequestsPerMinute = maxRequestsPerMinute,
				RemoteId = instance.Name,
				UserId = p2.UserId
			})
		end
	end
end

if IS_SERVER then
	local v2 = 0
	local function fn()
		if tick() > v2 + getConfiguration("ServerThrottleResetTimer") then
			v2 = tick()
			import2:Clear()
		end
	end

	serverTickFunctions[#serverTickFunctions + 1] = fn
end

return { rateLimitWarningHandler = rateLimitWarningHandler, default = createRateLimiter }