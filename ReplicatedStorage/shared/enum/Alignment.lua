local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("Alignment", { "Start", "Center", "End" }))