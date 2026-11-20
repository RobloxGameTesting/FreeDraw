local function some(list, callback): boolean
	for i, item in ipairs(list) do
		if callback(item, i, list) then
			return true
		end
	end

	return false
end

return some