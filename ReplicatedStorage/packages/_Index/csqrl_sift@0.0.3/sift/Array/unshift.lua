local function unshift(list, ...)
	local result = { ... }

	for _, item in ipairs(list) do
		table.insert(result, item)
	end

	return result
end

return unshift