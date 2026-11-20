local Func = {}

function Func.truthy(): boolean
	return true
end

function Func.noop() end

function Func.returned(...)
	return ...
end

return Func