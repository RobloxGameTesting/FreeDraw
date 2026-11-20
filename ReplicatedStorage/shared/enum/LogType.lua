local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("LogType", { Join = "JOIN", Leave = "LEAVE", Chat = "CHAT", Command = "COMMAND" }))