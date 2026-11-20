local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local RadialBar = require(ReplicatedStorage.client.ui.components.base.RadialBar)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local images = require(ReplicatedStorage.client.ui.assets.images)
local VotekickStatus = require(ReplicatedStorage.shared.enum.VotekickStatus)

local v = { frequency = 6, dampingRatio = 1 }
local v2 = { frequency = 7, dampingRatio = 1 }

local v3 = {
	[VotekickStatus.Kicked] = images.votekick.kicked,
	[VotekickStatus.NotKicked] = images.votekick.notKicked
}

local v4 = {
	[VotekickStatus.Kicked] = colors.green[700],
	[VotekickStatus.NotKicked] = colors.red[700]
}

local createElement = Roact.createElement

local function VotekickAvatar(props, p)
	local v5 = RoactFlipper.useSpring(p, props.status == VotekickStatus.Pending and 0 or 1, v2)
	local v6 = RoactFlipper.useSpring(p, props.status == VotekickStatus.Kicked and 1 or props.progress, v)

	local v7 = { size = UDim2.fromOffset(80, 80), layoutOrder = props.layoutOrder }
	local v8 = {
		Image = createElement(Image, {
			image = ("rbxthumb://type=AvatarHeadShot&w=150&h=150&id=%d"):format(props.player.UserId),
			circular = true,
			transparency = Binding.mapLerp(v5, 0, 0.9),
			size = UDim2.new(1, -8, 1, -8),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5)
		}),
		Result = createElement(Image, {
			image = v3[props.status],
			color = v4[props.status],
			transparency = Binding.mapLerp(v5, 1, 0),
			size = UDim2.fromOffset(36, 36),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 10
		}),
		Progress = createElement(RadialBar, {
			value = v6,
			thickness = 4,
			color = colors.brand,
			size = UDim2.fromScale(1, 1),
			zIndex = 10
		}),
		ProgressBackground = createElement(Box, {
			borderColor = colors.brand,
			borderThickness = 4,
			borderTransparency = 0.8,
			circular = true,
			transparency = 1,
			size = UDim2.new(1, -8, 1, -8),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 5
		}),
		Background = 0
	}
	local background

	if props.background then
		background = createElement(Box, {
			circular = true,
			size = UDim2.new(1, 8, 1, 8),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			zIndex = 0
		})
	end

	v8.Background = background
	return createElement(Container, v7, v8)
end

return (hook(VotekickAvatar, { componentType = "PureComponent" }))