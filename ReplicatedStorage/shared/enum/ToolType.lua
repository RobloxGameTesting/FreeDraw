local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("ToolType", { "Draw", "Line", "Erase", "Claim", "Shape", "Eyedropper" }))