local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "internal")
local isLuaTable = import.isLuaTable
local serverTickFunctions = import.ServerTickFunctions

local import2 = RuntimeLib.import(script, script.Parent, "MessagingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
RunService:IsStudio()

local function isSubscriptionMessage(p): boolean -- 1 equivalent call inferred from this helper
	if isLuaTable(p) then
		return p.Data ~= nil
	end

	return false
end

local function isJobTargetMessage(p): boolean -- 1 equivalent call inferred from this helper
	if isSubscriptionMessage(p) and isLuaTable(p.Data) then -- inferred equivalent call
		return p.Data.jobId ~= nil
	end

	return false
end

local v = {}
local v2 = 0
local count = 0
local count2 = 0
local default = nil
local function processMessageQueue()
	local now = tick()

	if v2 + 60 <= now then
		count = 0
		count2 = 0
		v2 = tick()

		while #v > 0 do
			local count3 = #v
			local v3 = v[count3]
			v[count3] = nil

			import2:PublishAsync(v3.Name, v3.Data)
			count += 1
		end

		if count >= default:GetMessageLimit() then
			warn("[rbx-net] Too many messages are being sent, any further messages will be queued!")
		end
	end
end

default = setmetatable({}, {
	__tostring = function(): string
		return "MessagingEvent"
	end
})

default.__index = default
function default.new(...)
	local object = setmetatable({}, default)
	return object:constructor(...) or object
end

function default:constructor(name)
	self.name = name
end
function default:GetMessageLimit()
	return #Players:GetPlayers() * 60 + 150
end

function default:GetSubscriptionLimit()
	return #Players:GetPlayers() * 2 + 5
end

function default:sendToAllServersOrQueue(p)
	local messageLimit = default:GetMessageLimit()

	if messageLimit <= count then
		warn("[rbx-net] Exceeded message limit of " .. tostring(messageLimit) .. ", adding to queue...")
		local v3 = { Name = self.name, Data = p }

		v[#v + 1] = v3
	else
		count += 1

		import2:PublishAsync(self.name, p)
	end
end
function default:SendToServer(jobId, message)
	self:sendToAllServersOrQueue({ jobId = jobId, message = message })
end
function default:SendToAllServers(p)
	self:sendToAllServersOrQueue(p)
end
function default.Connect(p, callback)
	local subscriptionLimit = default:GetSubscriptionLimit()

	if subscriptionLimit <= count2 then
		error("[rbx-net] Exceeded Subscription limit of " .. tostring(subscriptionLimit) .. "!")
	end

	count2 += 1
	return import2:SubscribeAsync(p.name, function(p2, sent2)
		local v3 = { Data = p2, Sent = sent2 }

		local sent = v3.Sent

		if isJobTargetMessage(v3) then -- inferred equivalent call
			local data = v3.Data

			if game.JobId == data.JobId then
				callback(data.InnerData, sent)
			end
		else
			callback(v3.Data, sent)
		end
	end)
end

serverTickFunctions[#serverTickFunctions + 1] = processMessageQueue

return { isSubscriptionMessage = isSubscriptionMessage, default = default }