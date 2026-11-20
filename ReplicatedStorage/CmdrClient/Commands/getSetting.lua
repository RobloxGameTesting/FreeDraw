local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local settings = require(ReplicatedStorage.shared.data.settings)
local ui = require(ReplicatedStorage.client.ui)
local settingsSlice = require(ReplicatedStorage.client.ui.fragments.settings.settingsSlice)

return {
	Name = "getSetting",
	Aliases = { "g" },
	Description = "Gets a setting.",
	Group = "Player",
	Args = {
		{ Name = "setting", Type = "setting" }
	},
	Run = function(_, p)
		local setting = settingsSlice.selectors.selectSetting(ui.store:getState(), p)
		return `{p} is set to {HttpService:JSONEncode((settings[p].type.encode(setting)))}`
	end
}