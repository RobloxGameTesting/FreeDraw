local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("ActionType", {
	"CreateLine",
	"DeleteLine",
	"EraseParts",
	"CreateLayer",
	"MoveLayer",
	"SetLayerVisible",
	"RenameLayer",
	"MergeLayer",
	"DeleteLayer"
}))