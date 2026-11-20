local function flatten(list, value: number?)
	local v = type(value) ~= "number" and 1e999 or value

	local result = {}

	for _, item in ipairs(list) do
		if type(item) == "table" and v > 0 then
			local v2 = flatten(item, v - 1)

			for _, v3 in ipairs(v2) do
				table.insert(result, v3)
			end
		else
			table.insert(result, item)
		end
	end

	return result
end

return flatten