local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "messaging", "MessagingEvent")
local default = import.default
local isSubscriptionMessage = import.isSubscriptionMessage
local import2 = RuntimeLib.import(script, script.Parent.Parent, "internal")
local getGlobalRemote = import2.getGlobalRemote
local IS_CLIENT = import2.IS_CLIENT
local isLuaTable = import2.isLuaTable
local default2 = RuntimeLib.import(script, script.Parent, "ServerEvent").default
local Players = game:GetService("Players")
local function isTargetedSubscriptionMessage(p): boolean -- 1 equivalent call inferred from this helper
	if isSubscriptionMessage(p) and isLuaTable(p.Data) then
		return p.Data.InnerData ~= nil
	end

	return false
end

local object = setmetatable({}, {
	__tostring = function(): string
		return "ServerMessagingEvent"
	end
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p)
	self.instance = default2.new(getGlobalRemote(p))
	self.event = default.new(p)

	assert(not IS_CLIENT, "Cannot create a Net.GlobalServerEvent on the Client!")
	self.eventHandler = self.event:Connect(function(p2)
		if isTargetedSubscriptionMessage(p2) then -- inferred equivalent call
			self:recievedMessage(p2.Data)
		else
			warn("[rbx-net] Recieved malformed message for ServerGameEvent: " .. p)
		end
	end)
end
function object:getPlayersMatchingId(list)
	if type(list) == "number" then
		return Players:GetPlayerByUserId(list)
	end

	local playerByUserIds = {}

	for _, item in ipairs(list) do
		local playerByUserId = Players:GetPlayerByUserId(item)

		if playerByUserId then
			playerByUserIds[#playerByUserIds + 1] = playerByUserId
		end
	end

	return playerByUserIds
end

function object:recievedMessage(data)
	if data.TargetIds then
		local playersMatchingId = self:getPlayersMatchingId(data.TargetIds)

		if playersMatchingId then
			self.instance:SendToPlayers(playersMatchingId, unpack(data.InnerData))
		end
	elseif data.TargetId == nil then
		self.instance:SendToAllPlayers(unpack(data.InnerData))
	else
		local playersMatchingId = self:getPlayersMatchingId(data.TargetId)

		if playersMatchingId then
			self.instance:SendToPlayer(playersMatchingId, unpack(data.InnerData))
		end
	end
end
function object:Disconnect()
	self.eventHandler:Disconnect()
end
function object:SendToAllServers(...)
	local v = { ... }
	local event = self.event
	local v2 = {}

	local v3 = {}
	local v4 = #v3
	table.move(v, 1, #v, v4 + 1, v3)
	v2.data = v3
	event:SendToAllServers(v2)
end
function object:SendToServer(p, ...)
	local v = { ... }
	local event = self.event
	local v2 = {}

	local v3 = {}
	local v4 = #v3
	table.move(v, 1, #v, v4 + 1, v3)
	v2.data = v3
	event:SendToServer(p, v2)
end
function object:SendToPlayer(targetId, ...)
	local v = { ... }
	local playerByUserId = Players:GetPlayerByUserId(targetId)

	if playerByUserId then
		self.instance:SendToPlayer(playerByUserId, unpack(v))
		return
	end

	local event = self.event

	local v3 = {}
	local v4 = #v3
	table.move(v, 1, #v, v4 + 1, v3)
	local v2 = { data = v3 }

	v2.targetId = targetId
	event:SendToAllServers(v2)
end
function object:SendToPlayers(targetIds, ...)
	local v = { ... }

	for _, targetId in ipairs(targetIds) do
		local playerByUserId = Players:GetPlayerByUserId(targetId)

		if not playerByUserId then
			continue
		end

		self.instance:SendToPlayer(playerByUserId, unpack(v))
		table.remove(targetIds, targetId + 1)
	end

	if #targetIds > 0 then
		local event = self.event

		local v3 = {}
		local v4 = #v3
		table.move(v, 1, #v, v4 + 1, v3)
		local v2 = { data = v3 }

		v2.targetIds = targetIds
		event:SendToAllServers(v2)
	end
end

return { default = object }