return {
	Name = "gear",
	Aliases = {},
	Description = "Gives a player a gear.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "players", Description = "Players to give the gear to" },
		{ Type = "integers", Name = "gearIds", Description = "Gear IDs to give to the players" }
	}
}