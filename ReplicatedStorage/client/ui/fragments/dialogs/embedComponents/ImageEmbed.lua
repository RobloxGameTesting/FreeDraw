local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)

local createElement = Roact.createElement

local function ImageEmbed(p, _)
	return createElement(Image, {
		image = p.options.id,
		scaleType = Enum.ScaleType.Crop,
		size = UDim2.new(1, 0, 0, p.options.height),
		automaticSize = Enum.AutomaticSize.Y,
		layoutOrder = p.layoutOrder
	}, {
		Corner = createElement("UICorner", { CornerRadius = UDim.new(0, 4) })
	})
end

return (hook(ImageEmbed, { componentType = "PureComponent" }))