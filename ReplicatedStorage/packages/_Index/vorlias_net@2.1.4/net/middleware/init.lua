local RuntimeLib = require(script.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script, "LoggerMiddleware")
local default = RuntimeLib.import(script, script, "RateLimitMiddleware").default
local import2 = RuntimeLib.import(script, script, "TypeCheckMiddleware")
local netMiddleware = {}

netMiddleware.RateLimit = default

netMiddleware.Logging = import

netMiddleware.TypeChecking = import2

function netMiddleware.Global(callback)
	return function(callback2, object)
		return function(p, ...)
			local v = { ... }
			callback(object:GetInstance().Name, v, p)
			return callback2(p, unpack(v))
		end
	end
end

return { NetMiddleware = netMiddleware, createRateLimiter = default, createTypeChecker = import2 }