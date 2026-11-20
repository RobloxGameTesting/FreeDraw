local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Sift = require(ReplicatedStorage.packages.Sift)

local IdentityType = require(ReplicatedStorage.shared.enum.IdentityType)
local identitySlice = require(script.Parent.identitySlice)
local containers = require(ReplicatedStorage.shared.containers)
local CollisionGroup = require(ReplicatedStorage.shared.enum.CollisionGroup)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function identityController(object)
	local v = nil
	local v2 = nil

	local function checkDrawing(p)
		local raycastParams = RaycastParams.new()
		raycastParams.CollisionGroup = CollisionGroup.Render.value
		raycastParams.FilterDescendantsInstances = { containers.drawing }
		raycastParams.FilterType = Enum.RaycastFilterType.Include

		local viewportPointToRay = CurrentCamera:ViewportPointToRay(p.X, p.Y)
		local raycastResult = Workspace:Raycast(
			viewportPointToRay.Origin,
			viewportPointToRay.Direction * 350,
			raycastParams
		)

		if not raycastResult then
			return nil
		end

		local playerByUserId = Players:GetPlayerByUserId(raycastResult.Instance.Parent.Parent.Parent:GetAttribute("owner"))

		if playerByUserId ~= LocalPlayer then
			return playerByUserId
		end

		return nil
	end

	local function checkClaim(p)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = Sift.List.filter(
			containers.claim:GetChildren(),
			function(instance): boolean
				return not instance:GetAttribute("temporary")
			end
		)

		raycastParams.FilterType = Enum.RaycastFilterType.Include

		local viewportPointToRay = CurrentCamera:ViewportPointToRay(p.X, p.Y)
		local raycastResult = Workspace:Raycast(
			viewportPointToRay.Origin,
			viewportPointToRay.Direction * 350,
			raycastParams
		)

		if raycastResult then
			local playerByUserId = Players:GetPlayerByUserId(raycastResult.Instance:GetAttribute("owner"))

			if playerByUserId ~= LocalPlayer then
				return playerByUserId
			end
		end

		return nil
	end

	local function check(p)
		local v3 = checkDrawing(p)

		if v3 then
			return IdentityType.Drawing, v3
		end

		local v4 = checkClaim(p)

		if v4 then
			return IdentityType.Claim, v4
		end
	end

	local function update()
		local mouseLocation = UserInputService:GetMouseLocation()
		local v3 = checkDrawing(mouseLocation)
		local v4

		if v3 then
			v4 = IdentityType.Drawing
		else
			v3 = checkClaim(mouseLocation)

			if v3 then
				v4 = IdentityType.Claim
			else
				v3 = nil
			end
		end

		if v4 ~= v or v3 ~= v2 then
			v = v4
			v2 = v3

			if v4 then
				object:dispatch(identitySlice.actions.setIdentity(v4, v3))
			else
				object:dispatch(identitySlice.actions.removeIdentity())
			end
		end
	end

	update()
	local heartbeatConnection = RunService.Heartbeat:Connect(update)

	return function()
		heartbeatConnection:Disconnect()
	end
end

return identityController