local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("ClaimError", {
	OverlapsClaim = "overlapsClaim",
	OverlapsDrawing = "overlapsDrawing",
	OverlapsSpawn = "overlapsSpawn",
	TooSmall = "tooSmall",
	TooBig = "tooBig",
	RateLimited = "rateLimited"
}))