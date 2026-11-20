local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("LoadSaveFileError", {
	DrawBanned = "drawBanned",
	OverlapsClaim = "overlapsClaim",
	RateLimited = "rateLimited",
	InternalError = "internalError"
}))