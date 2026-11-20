local ReplicatedStorage = game:GetService("ReplicatedStorage")

local platforms = require(ReplicatedStorage.client.platforms)

local function canvasColor(color)
	platforms.drawingPlatform.object.Color = color
end

return canvasColor