local Schema = {}

function Schema.Loose(items, p)
	if type(p) ~= "table" then
		return items
	end

	local result = {}

	for k, item in pairs(items) do
		result[k] = p[k] or item
	end

	return result
end

function Schema.Strict(items, p)
	if type(p) ~= "table" then
		return items
	end

	local result = {}

	for k, item in pairs(items) do
		if typeof(p[k]) == typeof(item) then
			result[k] = p[k]
		else
			result[k] = item
		end
	end

	return result
end

return Schema