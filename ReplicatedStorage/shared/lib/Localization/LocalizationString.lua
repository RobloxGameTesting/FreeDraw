local LocalizationString = {}
LocalizationString.__index = LocalizationString

function LocalizationString.new(p: string, arguments)
	return (setmetatable({ key = p, arguments = arguments }, LocalizationString))
end

function LocalizationString.is(p): boolean
	return getmetatable(p) == LocalizationString
end

return LocalizationString