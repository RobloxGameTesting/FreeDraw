local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("GeometryType", { "Circle", "Rectangle", "Polygon", "Star" }))