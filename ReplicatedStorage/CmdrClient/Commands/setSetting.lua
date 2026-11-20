local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local settings = require(ReplicatedStorage.shared.data.settings)
local ui = require(ReplicatedStorage.client.ui)
local settingsSlice = require(ReplicatedStorage.client.ui.fragments.settings.settingsSlice)

return {
	Name = "setSetting",
	Aliases = { "s" },
	Description = "Sets a setting.",
	Group = "Player",
	Args = {
		{ Name = "setting", Type = "setting" },
		{ Name = "data", Type = "json" }
	},
	Run = function(_, p, p2)
		ui.store:dispatch(settingsSlice.actions.set(p, settings[p].type.decode(p2)))

		return `Set {p} to {HttpService:JSONEncode(p2)}`
	end
}