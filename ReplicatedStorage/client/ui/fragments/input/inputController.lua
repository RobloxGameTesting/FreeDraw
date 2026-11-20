local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Promise = require(ReplicatedStorage.packages.Promise)

local Maid = require(ReplicatedStorage.shared.class.Maid)
local PointerType = require(ReplicatedStorage.shared.enum.PointerType)

local LocalPlayer = Players.LocalPlayer

local function getPlayerModule()
	return Promise.try(function()
		local playerModule = LocalPlayer:FindFirstChildOfClass("PlayerScripts"):WaitForChild("PlayerModule", 10)
		assert(playerModule, "Failed to load PlayerModule in time")
		return require(playerModule)
	end)
end

local function getEnabled(p): boolean -- 3 equivalent calls inferred from this helper
	return not p.camera.enabled or p.platform.pointer ~= PointerType.Touch
end

local function inputController(object)
	local v = Maid.new()
	local v2 = Promise.try(function()
		local playerModule = LocalPlayer:FindFirstChildOfClass("PlayerScripts"):WaitForChild("PlayerModule", 10)
		assert(playerModule, "Failed to load PlayerModule in time")
		return require(playerModule)
	end):andThen(function(object2)
		local controls = object2:GetControls()

		local function update(enabled) -- 2 equivalent calls inferred from this helper
			if enabled then
				controls:Enable()
			else
				controls:Disable()
			end

			if controls.touchGui then
				controls.touchGui.Enabled = enabled
			end
		end

		local state = object:getState()

		if state.camera.enabled and state.platform.pointer == PointerType.Touch then
			controls:Disable()
		end

		v:giveTasks({
			object.changed:connect(function(p, p2)
				local enabled = getEnabled(p2) -- inferred equivalent call
				local enabled2 = getEnabled(p) -- inferred equivalent call

				if enabled2 ~= enabled then
					update(enabled2) -- inferred equivalent call
				end
			end),
			UserInputService.LastInputTypeChanged:Connect(function()
				task.defer(function()
					update(getEnabled(object:getState())) -- inferred equivalent call
				end)
			end)
		})
	end)

	return function()
		v:clean()
		v2:cancel()
	end
end

return inputController