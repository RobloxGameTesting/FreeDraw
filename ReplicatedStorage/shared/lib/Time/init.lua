local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local Timer = require(ReplicatedStorage.shared.class.Timer)
local units = require(script.units)

local modulesByName = {}

for _, moduleScript in script.languages:GetChildren() do
	local name = moduleScript.Name
	local module = require(moduleScript)
	modulesByName[name] = module
end

local Time = {}

function Time.getRelativeString(p, value)
	local v = modulesByName.en

	if value then
		v = modulesByName[value:match("^([a-zA-Z]+)%-?[a-zA-Z]*$"):lower()] or v
	end

	local v2 = math.abs(p)

	local v3 = {
		seconds = math.floor(v2 / units.second),
		minutes = math.floor(v2 / units.minute),
		hours = math.floor(v2 / units.hour),
		days = math.floor(v2 / units.day),
		weeks = math.floor(v2 / units.week),
		months = math.floor(v2 / units.month),
		years = math.floor(v2 / units.year)
	}
	local v4 = nil

	for _, range in v.ranges do
		if v2 < range.max then
			local mapped = Sift.List.map(range.format, function(p2)
				return v3[p2]
			end)

			v4 = range.language:format(unpack(mapped))
			break
		end
	end

	if p > 0 then
		return (v.future:format(v4))
	end

	return (v.past:format(v4))
end

function Time.useRelativeString(p, p2, p3)
	local v, v2 = p.useBinding(Time.getRelativeString(p2, p3))

	p.useEffect(function()
		local function update() -- 1 equivalent call inferred from this helper
			v2(Time.getRelativeString(p2, p3))
		end

		update() -- inferred equivalent call
		local v3 = Timer.new(update, 10)

		return function()
			v3:stop()
		end
	end, { p2, p3 })

	return v
end

return Time