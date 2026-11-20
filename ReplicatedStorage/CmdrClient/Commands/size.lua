return {
	Name = "size",
	Aliases = { "sz" },
	Description = "Changes the size of a player's character. Ignores R6 characters.",
	Group = "MOD",
	Args = {
		{ Type = "players", Name = "players", Description = "Players to change size of" },
		{ Type = "number", Name = "heightScale", Description = "Height scale multiplier" },
		{ Type = "number", Name = "widthScale", Description = "Width scale multiplier" },
		{ Type = "number", Name = "depthScale", Description = "Depth scale multiplier" },
		{ Type = "number", Name = "headScale", Description = "Head scale multiplier" }
	}
}