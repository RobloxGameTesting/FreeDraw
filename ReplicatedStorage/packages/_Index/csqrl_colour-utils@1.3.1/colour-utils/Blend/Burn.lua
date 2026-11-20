local _Filter = require(script.Parent._Filter)

local lshift = bit32.lshift
local clamp = math.clamp
local max = math.max

return _Filter("Burn", function(p: number, p2: number)
	local v = clamp(p * 255, 0, 255)
	local v2 = p2 * 255

	if v ~= 0 or not v then
		return (max(0, 255 - lshift(255 - v2, 8) / v))
	end

	return v
end)