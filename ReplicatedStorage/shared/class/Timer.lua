local Timer = {}
Timer.__index = Timer

function Timer.new(callback, duration)
	local object = setmetatable({ _active = true }, Timer)

	task.spawn(function()
		while task.wait(duration) and object._active do
			callback()
		end
	end)

	return object
end

function Timer:stop()
	self._active = false
end

return Timer