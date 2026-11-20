local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("VotekickReason", {
	Scribbling = "scribbling",
	Griefing = "griefing",
	HateSpeech = "hateSpeech",
	Harassment = "harassment",
	Spamming = "spamming",
	Tracing = "tracing",
	Hacking = "hacking",
	FalseVotekicking = "falseVotekicking",
	Other = "other"
}))