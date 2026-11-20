return {
	Name = "join",
	Aliases = {},
	Description = "Joins the server a player is in, regardless of their privacy settings.",
	Group = "MOD",
	Args = {
		{ Type = "string", Name = "username", Description = "Username of the player to join" }
	}
}