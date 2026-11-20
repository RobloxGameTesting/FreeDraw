local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local hook = require(ReplicatedStorage.shared.util.hook)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)

local componentPropertyForwarder = createComponentPropertyForwarder({
	zIndex = "zIndex",
	visible = "visible"
})

local createElement = Roact.createElement

local function Shadow(p)
	local data = p.data

	local v = {
		image = data.image,
		color = colors.black,
		transparency = 0,
		scaleType = 0,
		sliceCenter = 0,
		size = 0,
		position = 0,
		anchorPoint = 0
	}
	local transparency

	if p.transparency then
		transparency = Binding.mapLerp(p.transparency, data.transparency, 1)
	else
		transparency = data.transparency
	end

	v.transparency = transparency
	local scaleType

	if data.slice then
		scaleType = Enum.ScaleType.Slice
	else
		scaleType = Enum.ScaleType.Stretch
	end

	v.scaleType = scaleType
	v.sliceCenter = data.slice

	v.size = UDim2.new(1, data.expand * 2, 1, data.expand * 2)
	v.position = UDim2.new(0.5, 0, 0.5, data.offset)
	v.anchorPoint = Vector2.new(0.5, 0.5)
	return createElement(Image, componentPropertyForwarder(p, v))
end

return (hook(Shadow, {
	componentType = "PureComponent",
	defaultProps = { zIndex = -1 }
}))