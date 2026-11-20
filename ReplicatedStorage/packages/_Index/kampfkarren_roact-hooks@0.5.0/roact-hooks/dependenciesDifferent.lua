local function dependenciesDifferent(items, items2): boolean
	local v = 0

	for k, item in pairs(items) do
		v += 1

		if item ~= items2[k] then
			return true
		end
	end

	for _ in pairs(items2) do
		v -= 1
	end

	return v ~= 0
end

return dependenciesDifferent