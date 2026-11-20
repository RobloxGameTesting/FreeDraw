local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local colorSlice = require(ReplicatedStorage.client.ui.fragments.options.optionSlices.colorSlice)
local containers = require(ReplicatedStorage.shared.containers)
local CollisionGroup = require(ReplicatedStorage.shared.enum.CollisionGroup)

local LocalPlayer = Players.LocalPlayer

local function eyedropperController(object)
	local function update(p)
		local child = containers.drawing:FindFirstChild(("Collector(%d)"):format(LocalPlayer.UserId))

		local vector3 = Vector3.new(p.X, 1, p.Y)

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Include
		raycastParams.FilterDescendantsInstances = { child }
		raycastParams.CollisionGroup = CollisionGroup.Render.value

		local raycastResult = Workspace:Raycast(vector3, Vector3.new(0, -2, 0), raycastParams)

		if raycastResult then
			local color = raycastResult.Instance.Color
			object:dispatch(colorSlice.actions.setRGB(color.R, color.G, color.B))
		end
	end

	return {
		handlePassiveInput = function()
			return { move = update }
		end,
		handleActiveInput = function()
			return { move = update }
		end
	}
end

return eyedropperController