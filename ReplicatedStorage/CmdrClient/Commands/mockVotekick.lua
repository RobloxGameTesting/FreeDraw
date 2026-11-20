return {
	Name = "mockVotekick",
	Aliases = {},
	Description = "Creates a votekick",
	Group = "CREATOR",
	Args = {
		{ Type = "player", Name = "target", Optional = true },
		{ Type = "player", Name = "source", Optional = true },
		{ Type = "votekickReason", Name = "reason", Optional = true }
	}
}