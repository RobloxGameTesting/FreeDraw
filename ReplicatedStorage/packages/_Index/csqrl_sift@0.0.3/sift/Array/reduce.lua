local function reduce(list, callback, p)
	local v

	if p then
		v = 1
	else
		p = list[1]
		v = 2
	end

	for i = v, #list do
		p = callback(p, list[i], i, list)
	end

	return p
end

return reduce