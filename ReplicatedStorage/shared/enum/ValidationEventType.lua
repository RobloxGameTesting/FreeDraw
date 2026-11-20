local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("ValidationEvent", { "Draw", "Load", "Overwrite", "Report", "Claim" }))