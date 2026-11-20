local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local make = require(ReplicatedStorage.shared.util.make)
local containers = require(ReplicatedStorage.shared.containers)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local class = {}
class.__index = class

function class.new(trackedObject, p)
	local self = setmetatable({ _trackedObject = trackedObject }, class)

	self.object = make("Part", {
		Anchored = true,
		CanCollide = true,
		Locked = true,
		TopSurface = Enum.SurfaceType.Smooth,
		BottomSurface = Enum.SurfaceType.Smooth,
		Parent = containers.platform
	})

	self.mesh = make("BlockMesh", { Parent = self.object })

	self:setVisualProperties(p)
	self:startUpdating()

	return self
end

function class:startUpdating()
	return RunService.Heartbeat:Connect(function()
		if self._trackedObject then
			local position = self._trackedObject.CFrame.Position
			self.object.CFrame = CFrame.new(position.X, -2.5, position.Z)
		end
	end)
end

function class:setTrackedObject(trackedObject)
	self._trackedObject = trackedObject
end

function class:setVisualProperties(data)
	self.object.Size = Vector3.new(data.size.X, 5, data.size.Y)
	self.mesh.Scale = Vector3.new(data.scale.X, 1, data.scale.Y)
	self.object.Color = data.color
	self.object.Transparency = data.transparency
end

local characterPlatform = class.new(LocalPlayer.Character, {
	size = Vector2.new(15, 15),
	scale = Vector2.new(1, 1),
	color = Color3.new(1, 1, 1),
	transparency = 1
})

local drawingPlatform = class.new(CurrentCamera, {
	size = Vector2.new(1000, 1000),
	scale = Vector2.new(4, 4),
	color = Color3.new(1, 1, 1),
	transparency = 0
})

local function setCharacter(character) -- 1 equivalent call inferred from this helper
	characterPlatform:setTrackedObject(character:WaitForChild("HumanoidRootPart"))
end

if LocalPlayer.Character then
	setCharacter(LocalPlayer.Character) -- inferred equivalent call
end

LocalPlayer.CharacterAdded:Connect(setCharacter)

return { characterPlatform = characterPlatform, drawingPlatform = drawingPlatform }