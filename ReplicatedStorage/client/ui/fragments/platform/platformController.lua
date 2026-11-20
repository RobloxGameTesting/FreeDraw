local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local PlatformType = require(ReplicatedStorage.shared.enum.PlatformType)
local PointerType = require(ReplicatedStorage.shared.enum.PointerType)
local platformSlice = require(script.Parent.platformSlice)
local make = require(ReplicatedStorage.shared.util.make)

local v = make("ScreenGui", {
	Name = "DummyGUI",
	IgnoreGuiInset = true,
	Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
})

local v2 = {
	[PointerType.Mouse] = {
		Enum.UserInputType.MouseButton1,
		Enum.UserInputType.MouseButton2,
		Enum.UserInputType.MouseButton3,
		Enum.UserInputType.MouseWheel,
		Enum.UserInputType.MouseMovement
	},
	[PointerType.Touch] = { Enum.UserInputType.Touch }
}

local function getPlatform(absoluteSize: Vector2) -- 2 equivalent calls inferred from this helper
	if absoluteSize.Y > absoluteSize.X and absoluteSize.X < 900 then
		return PlatformType.Phone
	end

	return PlatformType.Desktop
end

local function getOrientation(absoluteSize: Vector2) -- 2 equivalent calls inferred from this helper
	local v3 = math.min(absoluteSize.X, absoluteSize.Y)

	if v3 < 500 then
		return Enum.ScreenOrientation.Portrait
	end

	if v3 > 800 then
		return Enum.ScreenOrientation.LandscapeSensor
	end

	return Enum.ScreenOrientation.Sensor
end

local function getPointer(p) -- 2 equivalent calls inferred from this helper
	for k, list in v2 do
		if table.find(list, p) then
			return k
		end
	end

	return nil
end

local function platformController(object)
	object:dispatch(platformSlice.actions.setPlatform(getPlatform(v.AbsoluteSize))) -- inferred equivalent call
	object:dispatch(platformSlice.actions.setOrientation(getOrientation(v.AbsoluteSize))) -- inferred equivalent call
	object:dispatch(platformSlice.actions.setPointer(getPointer(UserInputService:GetLastInputType()))) -- inferred equivalent call

	local v3 = Maid.new({
		v:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			object:dispatch(platformSlice.actions.setPlatform(getPlatform(v.AbsoluteSize))) -- inferred equivalent call
			object:dispatch(platformSlice.actions.setOrientation(getOrientation(v.AbsoluteSize))) -- inferred equivalent call
		end),
		UserInputService.LastInputTypeChanged:Connect(function(p)
			local pointer = getPointer(p) -- inferred equivalent call

			if pointer then
				object:dispatch(platformSlice.actions.setPointer(pointer))
			end
		end)
	})

	return function()
		v3:clean()
	end
end

return platformController