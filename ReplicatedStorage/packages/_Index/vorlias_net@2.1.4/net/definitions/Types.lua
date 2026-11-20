local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)

return {
	DeclarationTypeCheck = RuntimeLib.import(script, script.Parent.Parent, "internal", "validator").oneOf(
		"Event",
		"Function",
		"AsyncFunction",
		"Namespace"
	)
}