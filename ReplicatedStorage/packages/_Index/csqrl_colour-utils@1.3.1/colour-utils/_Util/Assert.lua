local Assert = {}

local format = string.format

Assert.TYPE = {
	INVALID_TYPE = "%s(...): The `%s` argument must be a %s, but you passed %q (%s)",
	INVALID_ARRAY = "%s(...): The `%s` argument must be an array of %s, but you passed %q (%s) at index #%d",
	INVALID_EVAL_ARG = "%s(...): The `%s` argument must %s, but you passed %q (%s)"
}

function Assert.typeOf(p: string, p2: string, p3: string, p4)
	local v = format(Assert.TYPE.INVALID_TYPE, p, p2, p3, tostring(p4), (typeof(p4)))

	if typeof(p4) ~= p3 then
		error(v, 3)
	end

	return p4
end

function Assert.evalArg(p: string, p2: string, p3: string, flag: boolean?, p4)
	local v = format(Assert.TYPE.INVALID_EVAL_ARG, p, p2, p3, tostring(p4), (typeof(p4)))

	if flag ~= true then
		error(v, 3)
	end

	return p4
end

function Assert.arrayOf(p: string, p2: string, p3: string, list): nil
	Assert.typeOf("Assert.arrayOf", "array", "table", list)

	for i, item in ipairs(list) do
		if typeof(item) == p3 then
			continue
		end

		local v = format(Assert.TYPE.INVALID_ARRAY, p, p2, p3, tostring(item), typeof(item), i)

		error(v, 3)
	end

	return nil
end

function Assert.prepTypeOf(p: string)
	return function(p2: string, p3: string, p4)
		return Assert.typeOf(p, p2, p3, p4)
	end
end

function Assert.prepEvalArg(p: string)
	return function(p2: string, p3: string, flag: boolean?, p4)
		return Assert.evalArg(p, p2, p3, flag, p4)
	end
end

function Assert.prepArrayOf(p: string)
	return function(p2: string, p3: string, p4)
		return Assert.arrayOf(p, p2, p3, p4)
	end
end

return Assert