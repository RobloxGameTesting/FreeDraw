local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local CursorTracker = require(ReplicatedStorage.client.ui.fragments.cursor.CursorTracker)
local HoverEffect = require(ReplicatedStorage.client.ui.components.effect.HoverEffect)

local createElement = Roact.createElement

local function CursorEffect(p, props)
	local v = props.useMemo(Roact.createRef, {})

	props.useEffect(function()
		return function()
			CursorTracker.releaseCursor(v.current)
		end
	end, {})

	return createElement(HoverEffect, Sift.Dictionary.join(p, {
		shape = p.shape,
		onHover = props.useCallback(function(p2)
			if p2 then
				CursorTracker.setCursor(p.type, v.current)
			else
				CursorTracker.releaseCursor(v.current)
			end
		end, {}),
		[Roact.Ref] = v
	}))
end

return (hook(CursorEffect, {
	componentType = "PureComponent",
	defaultProps = { type = CursorType.Default, size = UDim2.new(1, 0, 1, 0), zIndex = -1000 }
}))