local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("FilterStatus", { "Loading", "Unfiltered", "Filtered" }))