local function isMixed(item)
	assert(type(item) == "table")
	local typeName = nil
	local v = false

	for k, item2 in next, item do
		if typeName and typeName ~= type(k) then
			return true
		end

		typeName = type(k)

		if type(item2) == "table" then
			v = v and isMixed(item2) and (getmetatable(item2) and true or false)
		end
	end

	return v
end

return { mixed = isMixed }