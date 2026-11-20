return {
	Name = "Kick",
	Aliases = {},
	Description = "Kicks a player from the server with a specified reason.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "players", Description = "Players to kick" },
		{
			Type = "string",
			Name = "reason",
			Description = "Reason to show on player(s) screen",
			Default = "No reason specified."
		}
	}
}