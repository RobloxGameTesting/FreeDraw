local Workspace = game:GetService("Workspace")

local CurrentCamera = Workspace.CurrentCamera

local function getCameraRotation(p)
	if p.camera.enabled then
		return p.camera.state.rotation
	end

	local lookVector = CurrentCamera.CFrame.LookVector
	return (math.atan2(lookVector.X, lookVector.Z) + 3.141592653589793) % 6.283185307179586
end

return getCameraRotation