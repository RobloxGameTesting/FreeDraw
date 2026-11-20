local function fromEntries(list)
	local result = {}

	for _, item in ipairs(list) do
		result[item[1]] = item[2]
	end

	return result
end

return fromEntries