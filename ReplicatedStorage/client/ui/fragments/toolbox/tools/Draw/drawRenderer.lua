local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local Stabilizer = require(ReplicatedStorage.shared.lib.Stabilizer)
local lineGenericRenderer = require(script.Parent.Parent.Parent.generic.lineGenericRenderer)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local function drawRenderer()
	return lineGenericRenderer(function(p)
		local tool = p.toolbox.tools[ToolType.Draw]

		local stabilizerType = tool.options.stabilizerType
		local stabilizerIntensity = tool.options.stabilizerIntensity

		return Sift.Dictionary.map(tool.lines, function(p2)
			return Stabilizer.stabilize(p2, stabilizerType, stabilizerIntensity)
		end)
	end)
end

return drawRenderer