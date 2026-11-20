local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local claimSlice = require(script.Parent.claimSlice)
local Vector = require(ReplicatedStorage.shared.lib.Vector)
local config = require(ReplicatedStorage.shared.data.config)
local isPro = require(ReplicatedStorage.shared.util.isPro)
local getCameraRotation = require(ReplicatedStorage.client.ui.fragments.camera.getCameraRotation)

local LocalPlayer = Players.LocalPlayer

local function adjustPointForMaxSize(position: Vector2, vector2: Vector2, cameraRotation: number)
	local rotated = Vector.rotate(position, -cameraRotation)
	local v = Vector.rotate(vector2, -cameraRotation) - rotated
	local v2

	if isPro(LocalPlayer) then
		v2 = config.tools.claim.bounds.max.pro
	else
		v2 = config.tools.claim.bounds.max.regular
	end

	local vector2_2 = Vector2.new(math.clamp(v.X, -v2.X, v2.X), (math.clamp(v.Y, -v2.Y, v2.Y)))

	return Vector.rotate(rotated + vector2_2, cameraRotation)
end

local function getSize(position: Vector2, vector2: Vector2, cameraRotation: number) -- 1 equivalent call inferred from this helper
	local rotated = Vector.rotate(position, -cameraRotation)
	local v = Vector.rotate(vector2, -cameraRotation) - rotated

	return (Vector2.new(math.abs(v.X), (math.abs(v.Y))))
end

local function claimController(object)
	return {
		handleActiveInput = function(p)
			local position = p.position
			local v = p.position

			local function update()
				local cameraRotation = getCameraRotation(object:getState())
				local v2 = adjustPointForMaxSize(position, v, cameraRotation)
				local lerped = position:Lerp(v2, 0.5)
				local size = getSize(position, v2, cameraRotation) -- inferred equivalent call
				object:dispatch(claimSlice.actions.setClaim(lerped, cameraRotation, size))
			end

			return {
				move = function(p2)
					v = p2
					update()
				end,
				release = function()
					object:dispatch(claimSlice.thunks.finishClaim())
				end,
				cancel = function()
					object:dispatch(claimSlice.actions.clearClaim())
				end
			}
		end
	}
end

return claimController