return {
	Name = "insert",
	Aliases = {},
	Description = "Inserts a model by ID at your current location.",
	Group = "ADMIN",
	Args = {
		{ Type = "integer", Name = "assetId", Description = "Asset ID of the model to insert" }
	}
}