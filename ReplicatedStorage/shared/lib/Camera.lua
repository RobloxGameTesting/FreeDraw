local Workspace = game:GetService("Workspace")
local CaptureService = game:GetService("CaptureService")
local Players = game:GetService("Players")

local CurrentCamera = Workspace.CurrentCamera
local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
local Camera = {}

function Camera.warpPosition(vector2: Vector2)
	if CurrentCamera:GetAttribute("flip") then
		vector2 = Vector2.new(CurrentCamera.ViewportSize.X - vector2.X, vector2.Y)
	end

	return vector2
end

function Camera.warpVector(vector2: Vector2)
	if CurrentCamera:GetAttribute("flip") then
		vector2 *= Vector2.new(-1, 1)
	end

	return vector2
end

function Camera.warpRotation(p: number)
	if CurrentCamera:GetAttribute("flip") then
		p = -p
	end

	return p
end

function Camera.capture(callback)
	local enabledsByLayerCollector = {}

	for _, layerCollector in playerGui:GetChildren() do
		if not layerCollector:IsA("LayerCollector") then
			continue
		end

		enabledsByLayerCollector[layerCollector] = layerCollector.Enabled
		layerCollector.Enabled = false
	end

	CaptureService:CaptureScreenshot(function(p)
		for k, enabled in enabledsByLayerCollector do
			k.Enabled = enabled
		end

		callback(p)
	end)
end

return Camera