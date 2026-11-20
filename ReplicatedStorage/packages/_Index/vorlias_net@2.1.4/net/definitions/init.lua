local RuntimeLib = require(script.Parent.TS.RuntimeLib)

local declarationTypeCheck = RuntimeLib.import(script, script, "Types").DeclarationTypeCheck
local serverDefinitionBuilder = RuntimeLib.import(script, script, "ServerDefinitionBuilder").ServerDefinitionBuilder
local clientDefinitionBuilder = RuntimeLib.import(script, script, "ClientDefinitionBuilder").ClientDefinitionBuilder
local warnOnce = RuntimeLib.import(script, script.Parent, "internal").warnOnce
local namespaceBuilder = RuntimeLib.import(script, script, "NamespaceBuilder").NamespaceBuilder
local default = {}

local function validateDeclarations(items)
	for _, item in pairs(items) do
		assert(declarationTypeCheck.check(item.Type), declarationTypeCheck.errorMessage)
	end
end

function default.Create(p, p2)
	validateDeclarations(p)
	return {
		Server = serverDefinitionBuilder.new(p, p2),
		Client = clientDefinitionBuilder.new(p)
	}
end

function default.Namespace(p)
	return { Type = "Namespace", Definitions = namespaceBuilder.new(p) }
end

function default.ServerAsyncFunction(serverMiddleware)
	return { Type = "AsyncFunction", ServerMiddleware = serverMiddleware }
end

function default.ClientAsyncFunction()
	return { Type = "AsyncFunction" }
end

function default.ServerFunction(serverMiddleware)
	return { Type = "Function", ServerMiddleware = serverMiddleware }
end

function default.ServerToClientEvent()
	return { ServerMiddleware = {}, Type = "Event" }
end

function default.ClientToServerEvent(serverMiddleware)
	return { Type = "Event", ServerMiddleware = serverMiddleware }
end

function default.BidirectionalEvent()
	return { Type = "Event", ServerMiddleware = {} }
end

function default.Function(serverMiddleware)
	warnOnce("Definition 'Function' is deprecated, use 'ServerFunction' in your declarations - https://github.com/roblox-aurora/rbx-net/issues/35")
	return { Type = "Function", ServerMiddleware = serverMiddleware }
end

function default.Event(serverMiddleware)
	warnOnce("Definition 'Event' is deprecated, use 'ServerToClientEvent', 'ClientToServerEvent' or 'BidirectionalEvent' in your declarations - https://github.com/roblox-aurora/rbx-net/issues/35")
	return { Type = "Event", ServerMiddleware = serverMiddleware }
end

function default.AsyncFunction(serverMiddleware)
	warnOnce("Definition 'AsyncFunction' is deprecated, use 'ServerAsyncFunction' or 'ClientAsyncFunction' in your declarations - https://github.com/roblox-aurora/rbx-net/issues/35")
	return { Type = "AsyncFunction", ServerMiddleware = serverMiddleware }
end

return { default = default }