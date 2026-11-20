local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lineGenericRenderer = require(script.Parent.Parent.Parent.generic.lineGenericRenderer)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local function lineRenderer()
	return lineGenericRenderer(function(p)
		return p.toolbox.tools[ToolType.Line].lines
	end)
end

return lineRenderer