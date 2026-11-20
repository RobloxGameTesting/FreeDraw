return {
	Name = "teleport",
	Aliases = { "tp" },
	Description = "Teleports players to another player.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "players", Description = "Players to teleport" },
		{ Type = "player", Name = "targetPlayer", Description = "Player to teleport to" }
	}
}