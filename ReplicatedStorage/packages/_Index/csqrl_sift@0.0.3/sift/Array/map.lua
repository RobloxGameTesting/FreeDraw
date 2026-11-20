local function map(list, callback)
	local result = {}

	for i, item in ipairs(list) do
		local v = callback(item, i, list)

		if v ~= nil then
			table.insert(result, v)
		end
	end

	return result
end

return map