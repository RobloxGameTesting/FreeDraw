return {
	Name = "setjumppower",
	Aliases = { "jumppower", "jp" },
	Description = "Sets a player's humanoid JumpPower value.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "players", Description = "Players to change JumpPower of" },
		{ Type = "number", Name = "jumpPower", Description = "Target JumpPower" }
	}
}