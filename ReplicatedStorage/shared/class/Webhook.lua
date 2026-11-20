local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HTTP = require(ReplicatedStorage.shared.lib.HTTP)

local Webhook = {
	flag = { SUPPRESS_NOTIFICATIONS = 4096, IS_COMPONENTS_V2 = 32768 },
	componentType = {
		ACTION_ROW = 1,
		BUTTON = 2,
		STRING_SELECT = 3,
		TEXT_INPUT = 4,
		USER_SELECT = 5,
		ROLE_SELECT = 6,
		MENTIONABLE_SELECT = 7,
		CHANNEL_SELECT = 8,
		SECTION = 9,
		TEXT_DISPLAY = 10,
		THUMBNAIL = 11,
		MEDIA_GALLERY = 12,
		FILE = 13,
		SEPARATOR = 14,
		CONTAINER = 17,
		LABEL = 18,
		FILE_UPLOAD = 19,
		RADIO_GROUP = 21,
		CHECKBOX_GROUP = 22,
		CHECKBOX = 23
	}
}

Webhook.__index = Webhook

function Webhook.new(url)
	return (setmetatable({ url = url }, Webhook))
end

function Webhook.send(p, body)
	return HTTP.request({
		url = p.url,
		method = "POST",
		body = body,
		query = { wait = "true", with_components = "true" }
	})
end

return Webhook