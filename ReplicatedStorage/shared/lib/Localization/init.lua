local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

require(ReplicatedStorage.packages.Roact)

local LocalizationProvider = require(script.LocalizationProvider)
local LocalizationString = require(script.LocalizationString)
local LocalizationContext = require(script.LocalizationContext)

local localProvider = LocalizationProvider.create(Players.LocalPlayer)

return {
	Provider = LocalizationProvider,
	String = LocalizationString,
	localProvider = localProvider,
	localContext = LocalizationContext.new(localProvider)
}