require(script.Parent.Parent.Types)

local function isEmpty(items): boolean
	return next(items) == nil
end

return isEmpty