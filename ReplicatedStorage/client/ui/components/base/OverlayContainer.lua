local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local make = require(ReplicatedStorage.shared.util.make)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)

local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

local target = make("ScreenGui", {
	IgnoreGuiInset = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	ResetOnSpawn = false,
	DisplayOrder = 100,
	Name = "OverlayGUI",
	Parent = playerGui
})

local createElement = Roact.createElement

local function OverlayContainer(props, p)
	local v, v2 = p.useBinding(Vector2.zero)
	local v3, v4 = p.useBinding(Vector2.zero)

	return createElement(Container, {
		size = props.size,
		sizeConstraint = props.sizeConstraint,
		position = props.position,
		anchorPoint = props.anchorPoint,
		rotation = props.rotation,
		layoutOrder = props.layoutOrder,
		[Roact.Change.AbsolutePosition] = p.useCallback(function(p2)
			v2(p2.AbsolutePosition)
		end, {}),
		[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
			v4(p2.AbsoluteSize)
		end, {}),
		[Roact.Event.InputBegan] = props[Roact.Event.InputBegan],
		[Roact.Event.InputChanged] = props[Roact.Event.InputChanged],
		[Roact.Event.InputEnded] = props[Roact.Event.InputEnded]
	}, {
		Portal = createElement(Roact.Portal, { target = target }, {
			[props.id] = createElement(Container, {
				size = v3:map(function(p2)
					return UDim2.fromOffset(p2.X, p2.Y)
				end),
				position = v:map(function(p2)
					return UDim2.fromOffset(p2.X, p2.Y)
				end),
				active = props.active,
				clipsDescendants = props.clipsDescendants,
				zIndex = props.zIndex,
				visible = props.visible
			}, props[Roact.Children])
		})
	})
end

return (hook(OverlayContainer, {
	componentType = "PureComponent",
	defaultProps = { id = "Container" }
}))