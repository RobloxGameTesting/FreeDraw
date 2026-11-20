local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactHooks = require(ReplicatedStorage.packages.RoactHooks)

return RoactHooks.new(Roact)