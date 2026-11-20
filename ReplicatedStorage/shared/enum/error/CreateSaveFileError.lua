local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("CreateSaveFileError", {
	RateLimited = "rateLimited",
	InternalError = "internalError"
}))