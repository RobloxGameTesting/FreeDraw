local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local images = require(ReplicatedStorage.client.ui.assets.images)

local createElement = Roact.createElement

local function Spinner(props, p)
	local v, v2 = p.useBinding(0)

	p.useEffect(function()
		local renderSteppedConnection = RunService.RenderStepped:Connect(function()
			v2(os.clock() / 0.75 % 1)
		end)

		return function()
			renderSteppedConnection:Disconnect()
		end
	end, {})

	return createElement(CanvasContainer, {
		transparency = props.transparency,
		size = UDim2.fromOffset(24, 24),
		position = props.position,
		anchorPoint = props.anchorPoint,
		zIndex = props.zIndex
	}, {
		Foreground = createElement(Image, {
			image = images.spinner.foreground,
			color = colors.brand,
			size = UDim2.fromScale(1, 1),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			rotation = Binding.mapLerp(v, 0, 360)
		}),
		Background = createElement(Image, {
			image = images.spinner.background,
			color = colors.grey[200],
			size = UDim2.fromScale(1, 1),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 0
		})
	})
end

return (hook(Spinner, { componentType = "PureComponent" }))