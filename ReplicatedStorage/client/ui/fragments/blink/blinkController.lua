local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local platforms = require(ReplicatedStorage.client.platforms)
local Input = require(ReplicatedStorage.shared.lib.Input)

local t = Enum.KeyCode.T

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Include
raycastParams.FilterDescendantsInstances = { platforms.drawingPlatform.object }

local function blinkController(object)
	local function blink(p) -- 2 equivalent calls inferred from this helper
		local character = LocalPlayer.Character

		if character then
			local viewportPointToRay = CurrentCamera:ViewportPointToRay(p.X, p.Y)
			local raycastResult = Workspace:Raycast(
				viewportPointToRay.Origin,
				viewportPointToRay.Direction * 500,
				raycastParams
			)

			if raycastResult then
				character:MoveTo(raycastResult.Position)
			end
		end
	end

	local lastTime = 0
	local v = Vector3.new(0, 0, 0)

	local v2 = Maid.new({
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.KeyCode == t then
				blink(UserInputService:GetMouseLocation()) -- inferred equivalent call
			end
		end),
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if
				not gameProcessed
				and input.UserInputType == Enum.UserInputType.Touch
				and not object:getState().toolbox.selectedTool
			then
				local position = input.Position

				local userInputStateChangedConnection = nil
				userInputStateChangedConnection = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
					if not Input.isActive(input) then
						if os.clock() - lastTime <= 0.2 and (input.Position - v).Magnitude <= 35 then
							blink(input.Position) -- inferred equivalent call
						elseif (input.Position - position).Magnitude <= 35 then
							lastTime = os.clock()
							v = position
						end

						userInputStateChangedConnection:Disconnect()
					end
				end)
			end
		end)
	})

	return function()
		v2:clean()
	end
end

return blinkController