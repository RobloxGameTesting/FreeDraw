local RuntimeLib = require(script.Parent.TS.RuntimeLib)
local default = RuntimeLib.import(script, script, "ServerAsyncFunction").default
local import = RuntimeLib.import(script, script, "ServerEvent")
local default2 = import.default
local default3 = import.default
local default4 = RuntimeLib.import(script, script, "ServerMessagingEvent").default
local default5 = RuntimeLib.import(script, script, "CreateServerListener").default
local default6 = RuntimeLib.import(script, script, "ServerFunction").default
local import2 = RuntimeLib.import(script, script.Parent, "configuration")

local function CreateEvent(p, p2)
	return default2.new(p, p2)
end

local Net = {}
Net.CreateEvent = CreateEvent

function Net.CreateAsyncFunction(p, p2)
	local v = p2 == nil and {} or p2

	return default.new(p, v)
end

function Net.CreateEvents(...)
	local v = {}

	for _, list in ipairs({ ... }) do
		if type(list) == "string" then
			local v2 = default2.new(list)

			v[#v + 1] = v2
		else
			local item = list[1]
			local v2 = { select(2, unpack(list)) }
			local v3 = default2.new(item, v2)

			v[#v + 1] = v3
		end
	end

	return unpack(v)
end

Net.Event = default3
Net.AsyncFunction = default
Net.Function = default6
Net.GameMessagingEvent = default4
Net.CreateListener = default5
Net.CreateSender = CreateEvent
Net.SetConfiguration = import2.SetConfiguration

Net.GetConfiguration = import2.GetConfiguration
return Net