local ThrottleLayer = require(script.Parent.ThrottleLayer)
local Error = require(script.Parent.Parent.Error)

local RetryLayer = {}

function RetryLayer._retry(callback, ...)
	local count = 0

	while count < 5 do
		count += 1

		local success, result = pcall(callback, ...)

		if success then
			return result
		end

		if count < 5 then
			warn(("[Quicksave] DataStore operation failed. Retrying...\nError:\n%s"):format((tostring(result))))
		else
			error(Error.new({
				kind = Error.Kind.DataStoreError,
				error = result,
				context = "Failed after 5 retries."
			}))
		end
	end
end

function RetryLayer.update(...)
	return RetryLayer._retry(function(...)
		return ThrottleLayer.update(...)
	end, ...)
end

function RetryLayer.read(...)
	return RetryLayer._retry(function(...)
		return ThrottleLayer.read(...)
	end, ...)
end

return RetryLayer