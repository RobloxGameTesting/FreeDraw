local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Boolean = require(script.Parent.inputs.Boolean)
local Color = require(script.Parent.inputs.Color)
local EnumImage = require(script.Parent.inputs.EnumImage)
local skies = require(ReplicatedStorage.client.ui.assets.skies)

return {
	{
		id = "environment",
		icon = "mountainOutline",
		settings = {
			{ id = "environment.canvasColor", component = Color },
			{
				id = "environment.sky",
				component = EnumImage,
				options = {
					size = 48,
					items = {
						{ id = "default", image = skies.default.front, name = "Default" },
						{
							id = "classicBlue",
							image = skies.classicBlue.front,
							name = "Classic Blue"
						},
						{ id = "classicRed", image = skies.classicRed.front, name = "Classic Red" },
						{ id = "jettellyDay", image = skies.jettellyDay.front, name = "Day" },
						{ id = "jettellyNight", image = skies.jettellyNight.front, name = "Night" },
						{ id = "jettellySpace", image = skies.jettellySpace.front, name = "Space" }
					}
				}
			}
		}
	},
	{
		id = "privacy",
		icon = "shieldOutline",
		settings = {
			{ id = "privacy.hideRole", component = Boolean },
			{ id = "privacy.hideTime", component = Boolean },
			{ id = "privacy.hidePro", component = Boolean }
		}
	}
}