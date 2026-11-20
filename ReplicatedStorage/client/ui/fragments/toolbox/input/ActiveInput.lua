local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

local Signal = require(ReplicatedStorage.shared.class.Signal)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local generateUniqueId = require(ReplicatedStorage.shared.util.generateUniqueId)
local getCanvasPosition = require(script.Parent.getCanvasPosition)
local Input = require(ReplicatedStorage.shared.lib.Input)

local ActiveInput = {}
ActiveInput.__index = ActiveInput

function ActiveInput.new()
	return (setmetatable({
		id = generateUniqueId(20),
		position = nil,
		onMove = Signal.new(),
		onRelease = Signal.new(),
		_maid = Maid.new()
	}, ActiveInput))
end

function ActiveInput.fromMouse()
	local v = ActiveInput.new()

	v:_handleScreenPosition(UserInputService:GetMouseLocation() - GuiService:GetGuiInset())

	v._maid:giveTasks({
		UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				v:_handleScreenPosition(input.Position)
			end
		end),
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				v:_handleRelease()
			end
		end)
	})

	return v
end

function ActiveInput.fromTouch(instance)
	local v = ActiveInput.new()

	v:_handleScreenPosition(instance.Position)

	v._maid:giveTasks({
		instance:GetPropertyChangedSignal("Position"):Connect(function()
			v:_handleScreenPosition(instance.Position)
		end),
		instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if not Input.isActive(instance) then
				v:_handleRelease()
			end
		end)
	})

	return v
end

function ActiveInput:_handleScreenPosition(p)
	local canvasPosition = getCanvasPosition(p)

	if canvasPosition then
		self.position = canvasPosition
		self.onMove:fire(canvasPosition)
	end
end

function ActiveInput:_handleRelease()
	self.onRelease:fire()
	self:destroy()
end

function ActiveInput:destroy()
	self._maid:clean()
end

return ActiveInput