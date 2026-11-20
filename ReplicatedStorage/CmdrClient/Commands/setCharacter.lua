return {
	Name = "setcharacter",
	Aliases = { "char" },
	Description = "Changes the character of a player to the specified Roblox user.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "players", Description = "Players to change characters of" },
		{
			Type = "string",
			Name = "targetUsername",
			Description = "Username of the target character"
		}
	}
}