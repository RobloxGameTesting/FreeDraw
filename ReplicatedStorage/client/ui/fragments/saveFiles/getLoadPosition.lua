local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local function getLoadPosition(p)
	if p.camera.enabled then
		return p.camera.state.position
	end

	local primaryPartCFrame = LocalPlayer.Character:GetPrimaryPartCFrame()
	return Vector2.new(primaryPartCFrame.X, primaryPartCFrame.Z)
end

return getLoadPosition