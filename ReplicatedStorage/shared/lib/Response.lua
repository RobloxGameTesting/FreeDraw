local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.packages.Promise)
local Response = {}

function Response.reply(p)
	return { success = true, data = p }
end

function Response.error(p)
	return { success = false, data = p }
end

function Response.promisify(p)
	if p.success then
		return Promise.resolve(p.data)
	end

	return Promise.reject(p.data)
end

return Response