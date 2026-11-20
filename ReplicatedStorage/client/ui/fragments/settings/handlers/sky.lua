local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local make = require(ReplicatedStorage.shared.util.make)
local skies = require(ReplicatedStorage.client.ui.assets.skies)

local v = make("Sky", { CelestialBodiesShown = false, Parent = Lighting })

local function sky(p) -- 1 equivalent call inferred from this helper
	local v2 = skies[p] or skies.default

	v.SkyboxUp = v2.up
	v.SkyboxDn = v2.down
	v.SkyboxFt = v2.front
	v.SkyboxBk = v2.back
	v.SkyboxLf = v2.left
	v.SkyboxRt = v2.right
end

sky("default") -- inferred equivalent call
return sky