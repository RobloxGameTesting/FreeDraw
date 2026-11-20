local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local cameraMouseController = require(script.Parent.cameraMouseController)
local cameraKeyboardController = require(script.Parent.cameraKeyboardController)
local cameraTouchController = require(script.Parent.cameraTouchController)

local CurrentCamera = Workspace.CurrentCamera

local function getPixelsPerStudWithZoom(zoom) -- 1 equivalent call inferred from this helper
	local viewportSize = CurrentCamera.ViewportSize
	local v = math.tan((math.rad(CurrentCamera.FieldOfView))) * zoom / 2
	return viewportSize.Y / v
end

local function cameraController(object)
	local v = nil

	local function getPixelsPerStud()
		return getPixelsPerStudWithZoom(object:getState().camera.state.zoom) -- inferred equivalent call
	end

	local function render(p)
		local state = p.camera.state

		CurrentCamera.CFrame = CFrame.new(state.position.X, state.zoom, state.position.Y) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.Angles(0, 0, state.rotation) * CFrame.new(
			0,
			0,
			0,
			state.flip and -1 or 1,
			0,
			0,
			0,
			1,
			0,
			0,
			0,
			1
		)
	end

	local function enable()
		v = Maid.new()

		if UserInputService.MouseEnabled then
			v:giveTask(cameraMouseController(object, getPixelsPerStud))
		end

		if UserInputService.KeyboardEnabled then
			v:giveTask(cameraKeyboardController(object))
		end

		if UserInputService.TouchEnabled then
			v:giveTask(cameraTouchController(object, getPixelsPerStud))
		end

		CurrentCamera.CameraType = Enum.CameraType.Scriptable
	end

	local function disable() -- 1 equivalent call inferred from this helper
		if v then
			v:clean()
			v = nil
		end

		CurrentCamera.CameraType = Enum.CameraType.Custom
	end

	local changedConnection = object.changed:connect(function(p, p2)
		local enabled = p.camera.enabled

		if enabled ~= p2.camera.enabled then
			if enabled then
				enable()
				render(p)
			else
				disable() -- inferred equivalent call
			end
		end

		if p.camera.state ~= p2.camera.state then
			render(p)
		end

		CurrentCamera:SetAttribute("flip", p.camera.state.flip)
	end)

	return function()
		changedConnection:disconnect()
	end
end

return cameraController