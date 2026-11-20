local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local modulesByName = {}

for _, moduleScript in ReplicatedStorage.shared.enum:GetDescendants() do
	if not moduleScript:IsA("ModuleScript") then
		continue
	end

	local name = moduleScript.Name
	local module = require(moduleScript)
	modulesByName[name] = module
end

local function makeCamelCase(value) -- 1 equivalent call inferred from this helper
	return value:sub(1, 1):lower() .. value:sub(2)
end

return function(registry)
	for k, v in modulesByName do
		local mapped = Sift.List.map(v.getEnumeratorItems(), function(p)
			return p.name
		end)

		local enumType = registry.Cmdr.Util.MakeEnumType(k, mapped)
		registry:RegisterType(makeCamelCase(k), enumType) -- inferred equivalent call
	end

	for _, v in Enum:GetEnums() do
		local mapped = Sift.List.map(v:GetEnumItems(), function(p)
			return p.Name
		end)

		local enumType = registry.Cmdr.Util.MakeEnumType(tostring(v), mapped)
		registry:RegisterType("roblox" .. tostring(v), enumType)
	end
end