local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local lineGenericRenderer = require(script.Parent.Parent.Parent.generic.lineGenericRenderer)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local getCameraRotation = require(ReplicatedStorage.client.ui.fragments.camera.getCameraRotation)
local generateGeometry = require(ReplicatedStorage.shared.render.generateGeometry)
local optionsSlice = require(ReplicatedStorage.client.ui.fragments.options.optionsSlice)

local function shapeRenderer()
	return lineGenericRenderer(function(p)
		local tool = p.toolbox.tools[ToolType.Shape]

		local cameraRotation = getCameraRotation(p)
		local options = optionsSlice.selectors.selectOptions(p)

		local options2 = tool.options
		return Sift.Dictionary.map(tool.shapes, function(p2)
			return generateGeometry(
				{
					options = options2,
					startPoint = p2.startPoint,
					endPoint = p2.endPoint,
					rotation = cameraRotation
				},
				options
			)
		end)
	end)
end

return shapeRenderer