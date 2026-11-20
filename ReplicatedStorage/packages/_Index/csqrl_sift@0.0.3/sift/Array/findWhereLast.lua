local function findWhereLast(list, callback, value: number?)
	local count = #list

	if type(value) == "number" then
		if value < 1 then
			value = count + value
		end
	else
		value = count
	end

	for whereLast = value, 1, -1 do
		if callback(list[whereLast], whereLast, list) then
			return whereLast
		end
	end
end

return findWhereLast