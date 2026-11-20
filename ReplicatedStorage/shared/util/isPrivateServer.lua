local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function isPrivateServer()
	return Players:GetAttribute("privateServer")
end

if RunService:IsServer() then
	game:SetAttribute("privateServer", game.PrivateServerId ~= "")
end

return isPrivateServer