local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Signal = require(ReplicatedStorage.shared.class.Signal)
local ActiveInput = require(script.ActiveInput)
local PassiveInput = require(script.PassiveInput)

local onActiveInput = Signal.new()
local onPassiveInput = Signal.new()
local currentActiveInputs = {}
local currentPassiveInputs = {}

local function addActiveInput(object)
	if not object.position then
		object:destroy()

		return
	end

	object.onRelease:connect(function()
		local index = table.find(currentActiveInputs, object)

		if index then
			table.remove(currentActiveInputs, index)
		end
	end)

	table.insert(currentActiveInputs, object)
	onActiveInput:fire(object)
end

local function addPassiveInput(p) -- 2 equivalent calls inferred from this helper
	p.onDestroy:connect(function()
		local index = table.find(currentPassiveInputs, p)

		if index then
			table.remove(currentPassiveInputs, index)
		end
	end)

	table.insert(currentPassiveInputs, p)
	onPassiveInput:fire(p)
end

if UserInputService.MouseEnabled then
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
			addActiveInput(ActiveInput.fromMouse())
		end
	end)

	addPassiveInput(PassiveInput.fromMouse()) -- inferred equivalent call
end

if UserInputService.TouchEnabled then
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.UserInputType == Enum.UserInputType.Touch then
			addActiveInput(ActiveInput.fromTouch(input))
			addPassiveInput(PassiveInput.fromTouch(input)) -- inferred equivalent call
		end
	end)
end

return {
	onActiveInput = onActiveInput,
	onPassiveInput = onPassiveInput,
	currentActiveInputs = currentActiveInputs,
	currentPassiveInputs = currentPassiveInputs
}