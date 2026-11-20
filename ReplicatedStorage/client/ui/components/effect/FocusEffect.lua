local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Collision = require(ReplicatedStorage.shared.lib.Collision)

local createElement = Roact.createElement

local function FocusEffect(props, p)
	local v = p.useMemo(Roact.createRef, {})

	p.useEffect(function()
		local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			local v2 = input.UserInputType == Enum.UserInputType.MouseButton1
			local v3 = input.UserInputType == Enum.UserInputType.Touch

			if v2 or v3 then
				local absolutePosition = v.current.AbsolutePosition
				local v4 = absolutePosition + v.current.AbsoluteSize

				if Collision.isPointWithinBounds(input.Position, absolutePosition, v4) then
					if props.onFocus then
						props.onFocus(input)
					end
				elseif props.onLostFocus then
					props.onLostFocus(input)
				end
			end
		end)

		return function()
			inputEndedConnection:Disconnect()
		end
	end, { props.onFocus, props.onLostFocus })

	return createElement(Container, {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		[Roact.Ref] = v
	})
end

return (hook(FocusEffect, { componentType = "PureComponent" }))