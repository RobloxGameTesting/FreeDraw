local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)

local function fn() end

local BaseMotor = {}
BaseMotor.__index = BaseMotor

function BaseMotor.new()
	return (setmetatable({
		_onStep = Signal.new(),
		_onStart = Signal.new(),
		_onComplete = Signal.new()
	}, BaseMotor))
end

function BaseMotor:onStep(p)
	return self._onStep:connect(p)
end

function BaseMotor:onStart(p)
	return self._onStart:connect(p)
end

function BaseMotor:onComplete(p)
	return self._onComplete:connect(p)
end

function BaseMotor:start()
	if not self._connection then
		self._connection = RunService.RenderStepped:Connect(function(dt)
			self:step(dt)
		end)
	end
end

function BaseMotor:stop()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

BaseMotor.destroy = BaseMotor.stop

BaseMotor.step = fn
BaseMotor.getValue = fn
BaseMotor.setGoal = fn

function BaseMotor.__tostring(_): string
	return "Motor"
end

return BaseMotor