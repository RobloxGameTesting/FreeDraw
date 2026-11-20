return {
	Name = "setwalkspeed",
	Aliases = { "speed", "ws" },
	Description = "Sets a player's humanoid WalkSpeed value.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "players", Description = "Players to change WalkSpeed of" },
		{ Type = "number", Name = "walkSpeed", Description = "Target WalkSpeed" }
	}
}