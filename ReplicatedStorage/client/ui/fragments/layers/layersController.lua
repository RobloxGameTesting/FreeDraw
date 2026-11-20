local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local layersSlice = require(script.Parent.layersSlice)
local Maid = require(ReplicatedStorage.shared.class.Maid)

local Trackers = Players.LocalPlayer:WaitForChild("Trackers")

local function layersController(object)
	local function updateLayers()
		local v = {}

		for _, child in Trackers:GetChildren() do
			local index = child:GetAttribute("index")
			v[index] = {
				id = child:GetAttribute("id"),
				name = child:GetAttribute("name"),
				visible = child:GetAttribute("visible"),
				index = index
			}
		end

		object:dispatch(layersSlice.actions.syncLayers(v))
	end

	updateLayers()

	local v = Maid.new({ Trackers.ChildAdded:Connect(updateLayers), Trackers.ChildRemoved:Connect(updateLayers) })

	return function()
		v:clean()
	end
end

return layersController