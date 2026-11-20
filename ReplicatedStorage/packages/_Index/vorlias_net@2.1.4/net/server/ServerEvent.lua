local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)
local import = RuntimeLib.import(script, script.Parent.Parent, "internal")
local findOrCreateRemote = import.findOrCreateRemote
local IS_CLIENT = import.IS_CLIENT
local IS_RUNNING = import.IS_RUNNING
local default = RuntimeLib.import(script, script.Parent, "MiddlewareEvent").default

local object = setmetatable({}, {
	__tostring = function(): string
		return "ServerEvent"
	end,
	__index = default
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(p, p2)
	local v = p2 == nil and {} or p2

	default.constructor(self, v)
	self.instance = findOrCreateRemote("RemoteEvent", p, function(p3)
		self.defaultHook = p3.OnServerEvent:Connect(object.DefaultEventHook)
	end)

	assert(not IS_CLIENT, "Cannot create a NetServerEvent on the client!")
end
function object.GetInstance(p)
	return p.instance
end

function object:Connect(p)
	local defaultHook = self.defaultHook

	if defaultHook ~= nil then
		defaultHook:Disconnect()
	end

	return (self.instance.OnServerEvent:Connect(function(p2, ...)
		local v = { ... }
		local v2 = self:_processMiddleware(p)

		if v2 ~= nil then
			v2(p2, unpack(v))
		end
	end))
end

function object.SendToAllPlayers(p, ...)
	if not IS_RUNNING then
		return nil
	end

	p.instance:FireAllClients(unpack({ ... }))
end
function object.SendToAllPlayersExcept(p, value, ...)
	local v = { ... }

	if not IS_RUNNING then
		return nil
	end

	local Players = game:GetService("Players")

	local function fn(player): boolean -- 1 equivalent call inferred from this helper
		return player ~= value
	end

	if typeof(value) == "Instance" then
		local players = Players:GetPlayers()
		local count = 0
		local players2 = {}

		for i, player in ipairs(players) do
			local _ = i - 1

			if fn(player) ~= true then -- inferred equivalent call
				continue
			end

			count += 1
			players2[count] = player
		end

		for _, player in ipairs(players2) do
			p.instance:FireClient(player, unpack(v))
		end
	elseif type(value) == "table" then
		for _, player in ipairs(Players:GetPlayers()) do
			if (table.find(value, player) or 0) - 1 == -1 then
				p.instance:FireClient(player, unpack(v))
			end
		end
	end
end
function object:SendToPlayer(player, ...)
	if not IS_RUNNING then
		return nil
	end

	self.instance:FireClient(player, unpack({ ... }))
end
function object:SendToPlayers(list, ...)
	local v = { ... }

	if not IS_RUNNING then
		return nil
	end

	for _, item in ipairs(list) do
		self:SendToPlayer(item, unpack(v))
	end
end
function object.DefaultEventHook(_, ...)
	local _ = { ... }
end

return { default = object }