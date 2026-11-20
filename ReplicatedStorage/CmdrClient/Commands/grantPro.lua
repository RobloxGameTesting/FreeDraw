return {
	Name = "grantPro",
	Aliases = {},
	Description = "Gives a specified user the specified duration of Pro subscription",
	Group = "ADMIN",
	Args = {
		{ Type = "string", Name = "username", Description = "Username of user to grant Pro to" },
		{ Type = "integer", Name = "duration", Description = "Duration of Pro to grant, in days" }
	}
}