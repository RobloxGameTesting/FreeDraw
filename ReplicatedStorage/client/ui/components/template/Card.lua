local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Shadow = require(ReplicatedStorage.client.ui.components.base.Shadow)
local shadows = require(ReplicatedStorage.client.ui.assets.shadows)
local CursorEffect = require(ReplicatedStorage.client.ui.components.effect.CursorEffect)

local createElement = Roact.createElement

local function Card(props, p)
	local v, v2 = p.useBinding(Vector2.new(0, 0))
	local size

	if props.size then
		size = props.size
	else
		size = v:map(function(p2)
			return UDim2.fromOffset(p2.X, p2.Y)
		end)
	end

	local v3 = {
		size = size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		visible = props.visible,
		active = true
	}

	local v4 = { radius = 12, transparency = props.transparency, size = UDim2.fromScale(1, 1) }

	local v5 = { size = UDim2.fromScale(1, 1) }
	local join = Sift.Dictionary.join
	local v6 = props[Roact.Children]
	local layout

	if not props.size then
		layout = createElement("UIListLayout", {
			[Roact.Change.AbsoluteContentSize] = p.useCallback(function(p2)
				v2(p2.AbsoluteContentSize)
			end, {})
		})
	end

	return createElement(Container, v3, {
		Content = createElement(CanvasContainer, v4, {
			Content = createElement(Container, v5, join(v6, { Layout = layout })),
			Background = createElement(Box, { size = UDim2.fromScale(1, 1), zIndex = 0 })
		}),
		Shadow = createElement(Shadow, { transparency = props.transparency, data = shadows.low[12] }),
		CursorEffect = createElement(CursorEffect)
	})
end

return (hook(Card, { componentType = "PureComponent" }))