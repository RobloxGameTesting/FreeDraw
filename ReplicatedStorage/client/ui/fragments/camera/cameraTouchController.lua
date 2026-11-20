local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Sift = require(ReplicatedStorage.packages.Sift)

local Input = require(ReplicatedStorage.shared.lib.Input)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local cameraSlice = require(script.Parent.cameraSlice)

local CurrentCamera = Workspace.CurrentCamera

local function cameraTouchController(object, callback)
	local v = {}

	local v2 = nil
	local v3 = nil
	local v4 = nil

	local function update()
		local v5 = callback()

		if #v == 1 then
			local v6 = v[1]

			object:dispatch(cameraSlice.actions.input({
				position = -Vector2.new(v6.Delta.X, v6.Delta.Y) / v5
			}))
		elseif #v == 2 then
			local v6 = v[1]
			local v7 = v[2]

			local vector2 = Vector2.new(v6.Position.X, v6.Position.Y)
			local vector2_2 = Vector2.new(v7.Position.X, v7.Position.Y)

			local v8 = vector2_2 - vector2

			local midpoint = (vector2 + vector2_2) / 2
			local v9 = math.atan2(v8.Y, v8.X)
			local magnitude = v8.Magnitude

			if v2 and v3 and v4 then
				local v10 = midpoint - v2
				local angleDelta = Number.getAngleDelta(v4, v9)
				local v11 = magnitude - v3

				local v12 = -(midpoint - CurrentCamera.ViewportSize / 2) / v5

				object:dispatch(cameraSlice.actions.input({
					position = -v10 / v5,
					rotation = angleDelta,
					zoom = -v11 / v5
				}, v12))

				v2 = midpoint
				v3 = magnitude
				v4 = v9
			else
				v2 = midpoint
				v3 = magnitude
				v4 = v9

				return
			end
		end

		object:flush()
	end

	local function reset() -- 2 equivalent calls inferred from this helper
		v2 = nil
		v3 = nil
		v4 = nil
		update()
	end

	local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if
			not gameProcessed
			and not object:getState().toolbox.selectedTool
			and input.UserInputType == Enum.UserInputType.Touch
		then
			v = Sift.List.push(v, input)
			reset() -- inferred equivalent call
			local v5 = nil
			v5 = Maid.new({
				input:GetPropertyChangedSignal("Position"):Connect(function()
					update()
				end),
				input:GetPropertyChangedSignal("UserInputState"):Connect(function()
					if not Input.isActive(input) then
						v5:clean()
						v = Sift.List.removeValue(v, input)
						reset() -- inferred equivalent call
					end
				end)
			})
		end
	end)

	return function()
		inputBeganConnection:Disconnect()
	end
end

return cameraTouchController