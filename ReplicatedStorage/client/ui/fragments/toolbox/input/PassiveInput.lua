local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Signal = require(ReplicatedStorage.shared.class.Signal)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local generateUniqueId = require(ReplicatedStorage.shared.util.generateUniqueId)
local getCanvasPosition = require(script.Parent.getCanvasPosition)
local Input = require(ReplicatedStorage.shared.lib.Input)

local PassiveInput = {}
PassiveInput.__index = PassiveInput

function PassiveInput.new()
	return (setmetatable({
		id = generateUniqueId(20),
		active = false,
		position = nil,
		onMove = Signal.new(),
		onActive = Signal.new(),
		onInactive = Signal.new(),
		onDestroy = Signal.new(),
		_maid = Maid.new()
	}, PassiveInput))
end

function PassiveInput.fromMouse()
	local v = PassiveInput.new()

	v:_handleScreenPosition(UserInputService:GetMouseLocation() - GuiService:GetGuiInset())

	v._maid:giveTask(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			v:_handleScreenPosition(input.Position)
		end
	end))

	return v
end

function PassiveInput.fromTouch(instance)
	local v = PassiveInput.new()

	v:_handleScreenPosition(instance.Position)

	v._maid:giveTasks({
		instance:GetPropertyChangedSignal("Position"):Connect(function()
			v:_handleScreenPosition(instance.Position)
		end),
		instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if not Input.isActive(instance) then
				v:destroy()
			end
		end)
	})

	return v
end

function PassiveInput:_handleScreenPosition(p)
	local canvasPosition = getCanvasPosition(p)

	self.position = canvasPosition

	if canvasPosition then
		if not self.active then
			self.active = true
			self.onActive:fire(canvasPosition)
		end

		self.onMove:fire(canvasPosition)
	elseif self.active then
		self.active = false
		self.onInactive:fire()
	end
end

function PassiveInput:destroy()
	if self._maid then
		self._maid:clean()
	end

	self.onDestroy:fire()
end

return PassiveInput