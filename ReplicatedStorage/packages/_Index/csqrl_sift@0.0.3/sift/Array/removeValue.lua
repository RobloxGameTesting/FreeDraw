local function removeValue(list, p)
	local result = {}

	for _, item in ipairs(list) do
		if item ~= p then
			table.insert(result, item)
		end
	end

	return result
end

return removeValue