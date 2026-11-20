local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("OverwriteSaveFileError", {
	RateLimited = "rateLimited",
	InternalError = "internalError"
}))