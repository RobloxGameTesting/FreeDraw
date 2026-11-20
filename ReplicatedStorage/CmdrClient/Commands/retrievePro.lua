return {
	Name = "retrievePro",
	Aliases = {},
	Description = "Gets the start and expiry dates of a user's Pro subscription",
	Group = "MOD",
	Args = {
		{ Type = "string", Name = "username", Description = "Username of user to grant Pro to" }
	}
}