local function set(list, total: number, p)
	local v = #list
	local result = {}

	if total < 1 then
		total += v
	end

	for i, item in ipairs(list) do
		if i == total then
			table.insert(result, p)
		else
			table.insert(result, item)
		end
	end

	return result
end

return set