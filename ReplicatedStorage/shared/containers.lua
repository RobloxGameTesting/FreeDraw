local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Sift = require(ReplicatedStorage.packages.Sift)

local make = require(ReplicatedStorage.shared.util.make)

local v = { drawing = "Drawing", claim = "Claim", platform = "Platform", admin = "Admin" }

local function createContainer(p: string)
	return (make("Folder", { Name = ("Container(%s)"):format(p), Parent = Workspace }))
end

local function findContainer(p: string)
	return Workspace:WaitForChild(("Container(%s)"):format(p))
end

if RunService:IsServer() then
	return (Sift.Dictionary.map(v, createContainer))
end

return (Sift.Dictionary.map(v, findContainer))