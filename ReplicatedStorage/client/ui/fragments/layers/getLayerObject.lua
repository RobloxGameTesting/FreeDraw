local Players = game:GetService("Players")

local Trackers = Players.LocalPlayer:WaitForChild("Trackers")

local function getLayerObject(p)
	for _, child in Trackers:GetChildren() do
		if child:GetAttribute("id") == p then
			return child.Value
		end
	end

	return nil
end

return getLayerObject