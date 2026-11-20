local function findWhere(list, callback, value: number?)
	local v = #list

	if type(value) == "number" then
		if value < 1 then
			value = v + value
		end
	else
		value = 1
	end

	for where = value, #list do
		if callback(list[where], where, list) then
			return where
		end
	end
end

return findWhere