return {
	multiply = function(items)
		local total = 0

		for _, item in items do
			total += (1 - total) * item
		end

		return total
	end
}