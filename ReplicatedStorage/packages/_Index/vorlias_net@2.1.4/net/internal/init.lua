local RuntimeLib = require(script.Parent.TS.RuntimeLib)
game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local v = not RunService:IsRunning() or RunService:IsServer()

local v2 = RunService:IsRunning() and RunService:IsClient()
local isRunning = RunService:IsRunning()

local function getGlobalRemote(p)
	return ":\\" .. p
end

local function isLuaTable(p): boolean
	return type(p) == "table"
end

local object = setmetatable({}, {
	__tostring = function(): string
		return "NetMiddlewareEvent"
	end
})

object.__index = object
function object.new(...)
	local object2 = setmetatable({}, object)
	return object2:constructor(...) or object2
end

function object:constructor(netInstance)
	self.netInstance = netInstance
end
function object:GetInstance()
	return self.netInstance:GetInstance()
end

local serverTickFunctions = {}

local function findOrCreateFolder(instance, name)
	local child = instance:FindFirstChild(name)

	if child then
		return child
	end

	local folder = Instance.new("Folder", instance)
	folder.Name = name
	return folder
end

local parent = script.Parent
local netManaged = parent:FindFirstChild("_NetManaged")

if not netManaged then
	netManaged = Instance.new("Folder", parent)
	netManaged.Name = "_NetManaged"
end

local function errorft(value, p)
	local v3 = string.gsub(value, "{([%w_][%w%d_]*)}", function(p2)
		local v3 = p[p2]
		return if v3 == nil then p2 else v3
	end)
	error(v3, 2)
end
local tracebackSet = {}
local function warnOnce(p)
	local traceback = debug.traceback()

	if tracebackSet[traceback] ~= nil then
		return nil
	end

	tracebackSet[traceback] = true

	warn("[rbx-net] " .. p)
end
local function format(value, p)
	return (string.gsub(value, "{([%w_][%w%d_]*)}", function(p2)
		local v3 = p[p2]
		return if v3 == nil then p2 else v3
	end))
end

local findRemote
local function waitForRemote(p, p2, p3)
	return RuntimeLib.Promise.defer(function(callback, callback2)
		local total = 0
		local v3

		repeat
			total += RunService.Heartbeat:Wait()
			v3 = findRemote(p, p2)
		until not (total < p3) or v3

		if v3 then
			callback(v3)
		else
			callback2("Timed out while waiting for " .. p .. " '" .. p2 .. "' after " .. tostring(p3) .. " seconds.")
		end
	end)
end

findRemote = function(p, p2)
	local function fn(p3): boolean -- 1 equivalent call inferred from this helper
		return p3.Name == p2
	end

	local function fn2(p3): boolean -- 1 equivalent call inferred from this helper
		return p3.Name == p2
	end

	local function fn3(p3): boolean -- 1 equivalent call inferred from this helper
		return p3.Name == p2
	end

	if p == "AsyncRemoteFunction" then
		local tagged = CollectionService:GetTagged("NetManagedAsyncFunction")

		for i, v3 in ipairs(tagged) do
			local _ = i - 1

			if fn(v3) == true then -- inferred equivalent call
				return v3
			end
		end

		return nil
	elseif p == "RemoteEvent" then
		local tagged = CollectionService:GetTagged("NetManagedEvent")

		for i, v3 in ipairs(tagged) do
			local _ = i - 1

			if fn2(v3) == true then -- inferred equivalent call
				return v3
			end
		end

		return nil
	else
		if p ~= "RemoteFunction" then
			error("Invalid Remote Access")
			return
		end

		local tagged = CollectionService:GetTagged("NetManagedLegacyFunction")

		for i, v3 in ipairs(tagged) do
			local _ = i - 1

			if fn3(v3) == true then -- inferred equivalent call
				return v3
			end
		end

		return nil
	end
end

local function getRemoteOrThrow(p, p2)
	local remote = findRemote(p, p2)

	if remote then
		return remote
	end

	error("Could not find Remote of type " .. p .. " called \"" .. p2 .. "\"")
end

local function findOrCreateRemote(p, name, callback)
	local remote = findRemote(p, name)

	if remote then
		if not CollectionService:HasTag(remote, "NetDefinitionManaged") then
			return remote
		end

		local v3 = "Fetching " .. p .. " '" .. name .. "', which is a DefinitionsManaged instance from a non-definitions context. This is considered unsafe."
		local traceback = debug.traceback()

		if tracebackSet[traceback] ~= nil then
			return remote
		end

		tracebackSet[traceback] = true

		warn("[rbx-net] " .. v3)

		return remote
	else
		if not v then
			error("Creation of Events or Functions must be done on server!")
		end

		local v3 = nil

		if p == "RemoteEvent" then
			v3 = Instance.new("RemoteEvent")
			CollectionService:AddTag(v3, "NetManagedEvent")
		elseif p == "AsyncRemoteFunction" then
			v3 = Instance.new("RemoteEvent")
			CollectionService:AddTag(v3, "NetManagedAsyncFunction")
		elseif p == "RemoteFunction" then
			v3 = Instance.new("RemoteFunction")
			CollectionService:AddTag(v3, "NetManagedLegacyFunction")
		else
			error("Invalid Remote Type: " .. p)
		end

		v3.Name = name
		v3.Parent = netManaged

		if callback ~= nil then
			callback(v3)
		end

		return v3
	end
end

local function checkArguments(list, p)
	if p == nil then
		warn("[net-types] Argument length is zero")
		return false
	end

	local flag = false
	local count = 0

	while true do
		if flag then
			count += 1
		else
			flag = true
		end

		if count < #list then
			if not list[count + 1](p[count + 1]) then
				warn("[net-types] Argument at index " .. tostring(count) .. " was invalid type.")
				return false
			end
		else
			return true
		end
	end
end

if v then
	local RunService2 = game:GetService("RunService")
	RunService2.Stepped:Connect(function(_, _)
		for _, v3 in ipairs(serverTickFunctions) do
			v3()
		end
	end)
end

return {
	getGlobalRemote = getGlobalRemote,
	isLuaTable = isLuaTable,
	findOrCreateFolder = findOrCreateFolder,
	errorft = errorft,
	warnOnce = warnOnce,
	format = format,
	waitForRemote = waitForRemote,
	findRemote = findRemote,
	getRemoteOrThrow = getRemoteOrThrow,
	findOrCreateRemote = findOrCreateRemote,
	checkArguments = checkArguments,
	IS_SERVER = v,
	IS_CLIENT = v2,
	IS_RUNNING = isRunning,
	MAX_CLIENT_WAITFORCHILD_TIMEOUT = 10,
	NetMiddlewareEvent = object,
	ServerTickFunctions = serverTickFunctions
}