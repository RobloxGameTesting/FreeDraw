return {
	makeEnum = function(p, list)
		local v = {}

		for _, item in ipairs(list) do
			v[item] = item
		end

		return (setmetatable(v, {
			__index = function(_, p2)
				error(string.format("%s is not in %s!", p2, p), 2)
			end,
			__newindex = function()
				error(string.format("Creating new members in %s is not allowed!", p), 2)
			end
		}))
	end
}