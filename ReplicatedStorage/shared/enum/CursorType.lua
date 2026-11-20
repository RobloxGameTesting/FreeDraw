local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("CursorType", {
	Draw = 0,
	Default = 1,
	Pointer = 2,
	Text = 3,
	Roblox = 4
}))