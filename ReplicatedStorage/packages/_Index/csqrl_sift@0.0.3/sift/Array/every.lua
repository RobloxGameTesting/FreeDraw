local function every(list, callback): boolean
	for i, item in ipairs(list) do
		if not callback(item, i, list) then
			return false
		end
	end

	return true
end

return every