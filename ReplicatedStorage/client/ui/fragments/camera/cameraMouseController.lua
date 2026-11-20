local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local cameraSlice = require(script.Parent.cameraSlice)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Input = require(ReplicatedStorage.shared.lib.Input)
local Camera = require(ReplicatedStorage.shared.lib.Camera)

local CurrentCamera = Workspace.CurrentCamera

local function getRotateHeld() -- 2 equivalent calls inferred from this helper
	return UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
end

local function getFineHeld() -- 4 equivalent calls inferred from this helper
	return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
end

local function cameraMouseController(object, callback)
	local v = false

	local function getAnchor()
		local v2 = (UserInputService:GetMouseLocation() - CurrentCamera.ViewportSize / 2) / callback()
		return Camera.warpVector(v2)
	end

	local v2 = Maid.new({
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			local v2 = not object:getState().toolbox.selectedTool
				and input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.MouseButton2
				or input.UserInputType == Enum.UserInputType.MouseButton3

			if not gameProcessed and not v and v2 then
				v = true

				local v3 = Vector2.new(input.Position.X, input.Position.Y)

				local v4 = nil
				v4 = Maid.new({
					UserInputService.InputChanged:Connect(function(input2)
						if input2.UserInputType == Enum.UserInputType.MouseMovement then
							local vector2 = Vector2.new(input2.Position.X, input2.Position.Y)

							if getRotateHeld() then -- inferred equivalent call
								local v5 = v3 - CurrentCamera.ViewportSize / 2
								local v6 = vector2 - CurrentCamera.ViewportSize / 2

								local v7 = math.atan2(v5.Y, v5.X)
								local v8 = math.atan2(v6.Y, v6.X)

								local angleDelta = Number.getAngleDelta(v7, v8)

								if getFineHeld() then -- inferred equivalent call
									angleDelta *= 0.2
								end

								object:dispatch(cameraSlice.actions.input({ rotation = angleDelta }))
							else
								local position = -(vector2 - v3) / callback()

								if getFineHeld() then -- inferred equivalent call
									position *= 0.2
								end

								object:dispatch(cameraSlice.actions.input({ position = position }))
							end

							object:flush()

							v3 = vector2
						end
					end),
					input:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if not Input.isActive(input) then
							v = false
							v4:clean()
						end
					end)
				})
			end
		end),
		UserInputService.InputChanged:Connect(function(input, gameProcessed)
			if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseWheel then
				if getRotateHeld() then -- inferred equivalent call
					local rotation = input.Position.Z * 0.3490658503988659

					if getFineHeld() then -- inferred equivalent call
						rotation *= 0.2
					end

					object:dispatch(cameraSlice.actions.input({ rotation = rotation }, getAnchor()))
				else
					local zoom = -input.Position.Z * 2.5

					if getFineHeld() then -- inferred equivalent call
						zoom *= 0.2
					end

					object:dispatch(cameraSlice.actions.input({ zoom = zoom }, getAnchor()))
				end

				object:flush()
			end
		end)
	})

	return function()
		v2:clean()
	end
end

return cameraMouseController