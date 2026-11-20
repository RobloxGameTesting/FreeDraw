local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("ToolboxError", { OverlapsClaim = "overlapsClaim", RateLimited = "rateLimited" }))