local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)

local function CoreGui(p, p2): nil
	local filtered = Sift.Dictionary.filter(p, function(_, p3)
		return table.find(Enum.CoreGuiType:GetEnumItems(), p3)
	end)

	p2.useEffect(function()
		for k, v in filtered do
			StarterGui:SetCoreGuiEnabled(k, v)
		end

		return function()
			for k in filtered do
				StarterGui:SetCoreGuiEnabled(k, true)
			end
		end
	end, {})

	return nil
end

return (hook(CoreGui, { componentType = "PureComponent" }))