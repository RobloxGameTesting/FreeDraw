local insert = table.insert
local Array = {}

function Array.map(list, callback)
	local result = {}

	for i, item in ipairs(list) do
		local v = callback(item, i)

		if v ~= nil then
			insert(result, v)
		end
	end

	return result
end

function Array.reduce(list, callback, p)
	local v

	if p then
		v = 1
	else
		p = list[1]
		v = 2
	end

	for i = v, #list do
		p = callback(p, list[i], i)
	end

	return p
end

return Array