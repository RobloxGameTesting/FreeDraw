local RuntimeLib = require(script.Parent.TS.RuntimeLib)
local default = RuntimeLib.import(script, script, "ClientAsyncFunction").default
local default2 = RuntimeLib.import(script, script, "ClientEvent").default
local default3 = RuntimeLib.import(script, script, "ClientMessagingEvent").default
local import = RuntimeLib.import(script, script.Parent, "configuration")
local default4 = RuntimeLib.import(script, script, "ClientEvent").default
local default5 = RuntimeLib.import(script, script, "ClientAsyncFunction").default
local import2 = RuntimeLib.import(script, script, "ClientFunction")
local default6 = import2.default
local default7 = import2.default
local setClientConfiguration = import.SetClientConfiguration
local getConfiguration = import.GetConfiguration
local Net = {}

function Net.GetEvent(p)
	return default4.new(p)
end

Net.GetEventAsync = RuntimeLib.async(function(p)
	return default4:Wait(p)
end)

Net.GetFunctionAsync = RuntimeLib.async(function(p)
	return default6:Wait(p)
end)

Net.GetAsyncFunctionAsync = RuntimeLib.async(function(p)
	return default5:Wait(p)
end)

function Net.GetAsyncFunction(p)
	return default5.new(p)
end

Net.SetConfiguration = setClientConfiguration
Net.GetConfiguration = getConfiguration
Net.Event = default2
Net.AsyncFunction = default
Net.GameMessagingEvent = default3
Net.Function = default7
return Net