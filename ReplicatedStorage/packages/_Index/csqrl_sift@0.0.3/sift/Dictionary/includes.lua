local function includes(items, p): boolean
	for _, item in pairs(items) do
		if item == p then
			return true
		end
	end

	return false
end

return includes