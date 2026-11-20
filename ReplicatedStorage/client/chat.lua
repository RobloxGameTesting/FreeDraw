local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local RichText = require(ReplicatedStorage.shared.lib.RichText)
local config = require(ReplicatedStorage.shared.data.config)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local function onIncomingMessage(p)
	local textSource = p.TextSource
	local playerByUserId

	if textSource then
		playerByUserId = Players:GetPlayerByUserId(textSource.UserId)
	end

	local textChatMessageProperties = Instance.new("TextChatMessageProperties")

	if playerByUserId and not playerByUserId:GetAttribute("hideRole") then
		local role = playerByUserId:GetAttribute("role")
		local role2 = config.group.roles[role]

		if role2.special then
			local formatByKey = Localization.localProvider:formatByKey(`role.{role}`)
			textChatMessageProperties.PrefixText = RichText.colored(`[{formatByKey}] {p.PrefixText}`, role2.color)
		end
	end

	return textChatMessageProperties
end

TextChatService.OnIncomingMessage = onIncomingMessage

return true