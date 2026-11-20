local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local platforms = require(ReplicatedStorage.client.platforms)

local drawingPlatform = platforms.drawingPlatform
local CurrentCamera = Workspace.CurrentCamera

local function getCanvasPosition(p)
	local screenPointToRay = CurrentCamera:ScreenPointToRay(p.X, p.Y)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = { drawingPlatform.object }

	local raycastResult = Workspace:Raycast(screenPointToRay.Origin, screenPointToRay.Direction * 500, raycastParams)

	if not raycastResult then
		return nil
	end

	local position = raycastResult.Position
	return Vector2.new(position.X, position.Z)
end

return getCanvasPosition