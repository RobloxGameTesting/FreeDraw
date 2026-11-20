local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enumerator = require(ReplicatedStorage.packages.enumerator)

return (enumerator("ValidationResult", { "Allow", "Deny", "Kick", "Ban" }))