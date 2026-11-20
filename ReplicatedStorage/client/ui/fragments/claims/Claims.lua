local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local Claim = require(script.Parent.Claim)
local Spawn = require(script.Parent.Spawn)
local hook = require(ReplicatedStorage.shared.util.hook)
local containers = require(ReplicatedStorage.shared.containers)

local createElement = Roact.createElement
local createFragment = Roact.createFragment

local function Claims(p)
	local children = {}

	for k, claim in p.claims do
		children[("Claim(%s)"):format(k)] = createElement(Claim, {
			player = Players:GetPlayerByUserId(k),
			position = claim.position,
			rotation = claim.rotation,
			size = claim.size
		})
	end

	return createFragment({
		Claims = createElement(Roact.Portal, { target = containers.claim }, children),
		Spawn = createElement(Roact.Portal, { target = Workspace }, {
			Spawn = createElement(Spawn, { radius = 128 })
		})
	})
end

local v = hook(Claims, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { claims = p.claims }
end)(v))