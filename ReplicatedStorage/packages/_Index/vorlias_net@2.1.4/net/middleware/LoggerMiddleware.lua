local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local isStudio = RunService:IsStudio()

local function defaultLogger(p, list)
	if isStudio then
		local v = {}

		for _, item in ipairs(list) do
			table.insert(v, HttpService:JSONEncode(item))
		end

		print("[rbx-net] Called", p, "with arguments", "[ " .. table.concat(v, ", ") .. " ]")
	end
end

return function(options)
	local v = options or {}
	local logger = v.Logger or defaultLogger

	return function(callback, object)
		local name = v.Name or object:GetInstance().Name
		return function(p, ...)
			logger(name, { ... })
			return callback(p, ...)
		end
	end
end