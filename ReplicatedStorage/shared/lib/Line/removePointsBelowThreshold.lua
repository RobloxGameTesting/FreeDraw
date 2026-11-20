local function removePointsBelowThreshold(items, p)
	local result = {}

	for _, item in items do
		if #result == 0 or p <= (result[#result] - item).Magnitude then
			table.insert(result, item)
		end
	end

	return result
end

return removePointsBelowThreshold