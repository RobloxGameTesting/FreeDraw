local RuntimeLib = require(script.TS.RuntimeLib)
local import = RuntimeLib.import(script, script, "server")
local import2 = RuntimeLib.import(script, script, "client")
local default = RuntimeLib.import(script, script, "definitions").default
local netMiddleware = RuntimeLib.import(script, script, "middleware").NetMiddleware
local import3 = RuntimeLib.import(script, script, "serialization")

local Net = {}

Net.Client = import2

Net.Server = import

Net.Definitions = default

Net.VERSION = "2.1.4 (Luau)"

Net.Middleware = netMiddleware

Net.Serialization = import3

return Net