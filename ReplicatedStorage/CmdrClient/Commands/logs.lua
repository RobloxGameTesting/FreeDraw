return {
	Name = "logs",
	Aliases = {},
	Description = "Gets the latest admin logs.",
	Group = "MOD",
	Args = {
		{ Type = "string", Name = "filter", Description = "Search query", Optional = true }
	}
}