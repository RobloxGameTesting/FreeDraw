local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local settings = require(ReplicatedStorage.shared.data.settings)

local v = {}
local canvasColor = require(script.Parent.handlers.canvasColor)
v["environment.canvasColor"] = canvasColor
local sky = require(script.Parent.handlers.sky)
v["environment.sky"] = sky

local mapped = Sift.Dictionary.map(settings, function(p)
	return p.default
end)

local function settingsController(object)
	local changedConnection = object.changed:connect(function(p, p2)
		if p.settings ~= p2.settings then
			local settings2 = p.settings or mapped
			local settings3 = p2.settings or mapped

			for k in settings do
				local v2 = v[k]

				if not v2 then
					continue
				end

				local setting = settings2[k]

				if setting ~= settings3[k] then
					v2(setting)
				end
			end
		end
	end)

	local settings2 = object:getState().settings or mapped

	for k in settings do
		local v2 = v[k]

		if v2 then
			v2(settings2[k])
		end
	end

	return function()
		changedConnection:disconnect()
	end
end

return settingsController