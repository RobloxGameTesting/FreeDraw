local _Filter = require(script.Parent._Filter)

local lshift = bit32.lshift
local clamp = math.clamp
local min = math.min

return _Filter("Dodge", function(p: number, p2: number)
	local v = clamp(p * 255, 0, 255)
	local v2 = p2 * 255

	if v ~= 255 or not v then
		return (min(255, lshift(v2, 8) / (255 - v)))
	end

	return v
end)