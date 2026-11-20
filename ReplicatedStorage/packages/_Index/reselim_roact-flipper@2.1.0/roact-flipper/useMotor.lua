local Flipper = require(script.Parent.Parent.Flipper)

local function createMotor(p)
	local typeName = type(p)

	if typeName == "number" then
		return Flipper.SingleMotor.new(p)
	elseif typeName == "table" then
		return Flipper.GroupMotor.new(p)
	end

	error(("Invalid type for initialValue. Expected \"number\" or \"table\", got \"%s\""):format(typeName))
end

local function useMotor(p, p2)
	local value = p.useValue(createMotor(p2)).value

	p.useEffect(function()
		return function()
			value:destroy()
		end
	end, {})

	return value
end

return useMotor