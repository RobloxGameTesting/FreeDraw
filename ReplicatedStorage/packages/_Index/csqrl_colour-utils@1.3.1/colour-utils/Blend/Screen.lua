local _Filter = require(script.Parent._Filter)
local rshift = bit32.rshift

return _Filter("Screen", function(p: number, p2: number)
	return 255 - rshift((255 - p2 * 255) * (255 - p * 255), 8)
end)