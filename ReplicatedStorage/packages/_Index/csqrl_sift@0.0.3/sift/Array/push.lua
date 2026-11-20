local function push(list, ...)
	local result = {}

	for _, item in ipairs(list) do
		table.insert(result, item)
	end

	for _, v in ipairs({ ... }) do
		table.insert(result, v)
	end

	return result
end

return push