local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local getLayerObject = require(ReplicatedStorage.client.ui.fragments.layers.getLayerObject)
local tools = require(script.Parent.tools)

local function rendererController(p)
	local mapped = Sift.Dictionary.map(tools, function(p2)
		local renderer = p2.renderer

		if renderer then
			return (renderer())
		end

		return nil
	end)

	local changedConnection = p.changed:connect(function(p2, p3)
		local layers = p2.layers.layers
		local layer = layers[Sift.List.findWhere(layers, function(p4)
			return p4 and p4.id == p2.layers.selectedLayer
		end)]

		if layer then
			local layerObject = getLayerObject(layer.id)
			local v = Sift.Dictionary.set(layer, "object", layerObject)

			for _, v2 in mapped do
				v2.render(p2, p3, v)
			end
		end
	end)

	return function()
		for _, v in mapped do
			v.destroy()
		end

		changedConnection:disconnect()
	end
end

return rendererController