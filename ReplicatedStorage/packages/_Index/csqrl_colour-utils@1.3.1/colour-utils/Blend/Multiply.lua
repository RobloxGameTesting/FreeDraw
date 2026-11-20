local _Filter = require(script.Parent._Filter)

return _Filter("Multiply", function(p: number, p2: number)
	return p2 * 255 * (p * 255) / 255
end)