local function toArray(items)
	local array = {}

	for k, _ in pairs(items) do
		table.insert(array, k)
	end

	return array
end

return toArray