local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local CmdrButton = require(script.Parent.buttons.CmdrButton)
local PlayerListButton = require(script.Parent.buttons.PlayerListButton)
local ScreenshotButton = require(script.Parent.buttons.ScreenshotButton)
local config = require(ReplicatedStorage.shared.data.config)

local LocalPlayer = Players.LocalPlayer

local createElement = Roact.createElement
local createFragment = Roact.createFragment

local function Topbar(p)
	local element = createElement(ScreenshotButton, { order = 1 })
	local element2 = createElement(PlayerListButton, { order = 2 })
	local v

	if p.showCmdrButton then
		v = createElement(CmdrButton, { order = 0 })
	end

	return createFragment({ element, element2, v })
end

return (RoactRodux.connect(function(p)
	local role = p.players[LocalPlayer.UserId].role
	return {
		showCmdrButton = config.group.roles[role].level ~= "PLAYER"
	}
end)(Topbar))