local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local settings = require(ReplicatedStorage.shared.data.settings)

return function(registry)
	registry:RegisterType("setting", (registry.Cmdr.Util.MakeEnumType("Setting", Sift.Dictionary.keys(settings))))
end