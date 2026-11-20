return {
	stackSkipAssert = function(p, message)
		if not p then
			error(message, 3)
		end
	end
}