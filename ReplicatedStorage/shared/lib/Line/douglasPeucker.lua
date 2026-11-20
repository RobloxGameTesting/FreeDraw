local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local function slice(list, p: number, p2: number) -- 2 equivalent calls inferred from this helper
	return table.move(list, p, p2, 1, table.create(p2 - p + 1))
end

local function perpendicularDistance(p, item, item2) -- 1 equivalent call inferred from this helper
	local v = p - item
	local v2 = item2 - item
	return (math.abs(v.Unit:Cross(v2.Unit) * v.Magnitude))
end

local function douglasPeucker(list, p)
	local count = #list

	if count <= 2 then
		return list
	end

	local item = list[1]
	local item2 = list[count]
	local v = 0
	local v2 = 0

	for i = 2, #list - 1 do
		local v3 = perpendicularDistance(list[i], item, item2) -- inferred equivalent call

		if not (v < v3) then
			continue
		end

		v2 = i
		v = v3
	end

	if not (p < v) then
		return { item, item2 }
	end

	local v3 = douglasPeucker(slice(list, 1, v2 - 1), p) -- inferred equivalent call
	local v4 = douglasPeucker(slice(list, v2, #list), p) -- inferred equivalent call
	return Sift.List.concat(v3, v4)
end

return douglasPeucker