local function freezeDeep(list)
	local result = {}

	for i = 1, #list do
		local item = list[i]

		if type(item) == "table" then
			table.insert(result, freezeDeep(item))
		else
			table.insert(result, item)
		end
	end

	table.freeze(result)

	return result
end

return freezeDeep