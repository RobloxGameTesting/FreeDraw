return {
	Name = "clean",
	Aliases = {},
	Description = "Cleans up anything created by an admin.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "admins", Description = "Players to clean up" }
	}
}