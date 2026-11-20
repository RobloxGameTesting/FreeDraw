local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local isStudio = RunService:IsStudio()

local class = {}
class.__index = class

function class.defaultErrorHandler(object, p, p2)
	local name = object:GetInstance().Name

	if isStudio then
		warn("[TypeCheckMiddleware] Call to " .. name .. " failed")
		warn("\tRecieved: " .. HttpService:JSONEncode(p))
		warn("\tInvalid argument at index " .. tostring(p2))
	end
end

local function typeCheckMiddleware(...)
	local v = { ... }
	local class2 = {}
	class2.__index = class2

	function class2:next(callback, p)
		local errorHandler = self.errorHandler or class.defaultErrorHandler

		return function(p2, ...)
			local v2 = { ... }

			for i, v3 in ipairs(v) do
				if not v3(v2[i]) then
					pcall(errorHandler, p, v2, i)
					return false
				end
			end

			return callback(p2, ...)
		end
	end

	function class2.__tostring(): string
		return "TypeCheckMiddleware"
	end

	function class2:WithErrorHandler(errorHandler)
		self.errorHandler = errorHandler
		return self
	end

	function class2:__call(...)
		return self:next(...)
	end

	return (setmetatable({}, class2))
end

function class.__call(_, ...)
	return typeCheckMiddleware(...)
end

function class.SetDefaultErrorHandler(_, defaultErrorHandler)
	class.defaultErrorHandler = defaultErrorHandler
end

return (setmetatable({}, class))