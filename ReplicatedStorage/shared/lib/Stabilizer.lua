local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Number = require(script.Parent.Number)
local StabilizerType = require(ReplicatedStorage.shared.enum.StabilizerType)

local function stabilizeRope(items, p)
	local lerped = Number.lerp(0, 3, p)

	local result = {}

	for _, item in items do
		local v = result[#result]

		if v then
			local v2 = item - v
			local magnitude = v2.Magnitude

			if lerped < magnitude then
				table.insert(result, v + v2.Unit * (magnitude - lerped))
			end
		else
			table.insert(result, item)
		end
	end

	return result
end

local function stabilizeWindow(items, p)
	local v = 1 - (1 - p) ^ 4

	local lerped = Number.lerp(1, 0.05, v)

	local result = {}

	for _, item in items do
		local v2 = result[#result]

		if v2 then
			table.insert(result, v2:Lerp(item, lerped))
		else
			table.insert(result, item)
		end
	end

	return result
end

return {
	stabilizeRope = stabilizeRope,
	stabilizeWindow = stabilizeWindow,
	stabilize = function(p, p2, p3)
		if p2 == StabilizerType.Rope then
			return stabilizeRope(p, p3)
		end

		if p2 == StabilizerType.Window then
			return stabilizeWindow(p, p3)
		end

		return p
	end
}