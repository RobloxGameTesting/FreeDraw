local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local cameraSlice = require(script.Parent.cameraSlice)
local Input = require(ReplicatedStorage.shared.lib.Input)

local i = Enum.KeyCode.I
local o = Enum.KeyCode.O
local f = Enum.KeyCode.F

local function getRotateHeld() -- 1 equivalent call inferred from this helper
	return UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
end

local function getFineHeld() -- 1 equivalent call inferred from this helper
	return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
end

local function cameraKeyboardController(object)
	local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed then
			if input.KeyCode == i or input.KeyCode == o then
				local v = nil
				v = Maid.new({
					RunService.RenderStepped:Connect(function(dt)
						local v2 = 0

						if input.KeyCode == i then
							v2 -= 1
						elseif input.KeyCode == o then
							v2 += 1
						end

						if getFineHeld() then -- inferred equivalent call
							v2 *= 0.2
						end

						if getRotateHeld() then -- inferred equivalent call
							object:dispatch(cameraSlice.actions.input({
								rotation = dt * 3.141592653589793 * -v2
							}, Vector2.zero))
						else
							object:dispatch(cameraSlice.actions.input({
								zoom = dt * 20 * v2
							}, Vector2.zero))
						end
					end),
					input:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if not Input.isActive(input) then
							v:clean()
						end
					end)
				})
			elseif input.KeyCode == f then
				object:dispatch(cameraSlice.actions.flip())
			end
		end
	end)

	return function()
		inputBeganConnection:Disconnect()
	end
end

return cameraKeyboardController