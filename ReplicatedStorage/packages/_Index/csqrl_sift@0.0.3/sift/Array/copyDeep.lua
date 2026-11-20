local function copyDeep(list)
	local result = {}

	for _, item in ipairs(list) do
		if type(item) == "table" then
			table.insert(result, copyDeep(item))
		else
			table.insert(result, item)
		end
	end

	return result
end

return copyDeep