local function removeIndices(list, ...)
	local v = #list
	local set = {}
	local result = {}

	for _, total in ipairs({ ... }) do
		if total < 1 then
			total += v
		end

		set[total] = true
	end

	for i, item in ipairs(list) do
		if not set[i] then
			table.insert(result, item)
		end
	end

	return result
end

return removeIndices