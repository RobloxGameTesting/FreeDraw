local function fromArray(list)
	local result = table.create(#list)

	for _, item in ipairs(list) do
		result[item] = true
	end

	return result
end

return fromArray