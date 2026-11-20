local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Number = require(ReplicatedStorage.shared.lib.Number)
local Input = require(ReplicatedStorage.shared.lib.Input)
local Button = require(ReplicatedStorage.client.ui.components.base.Button)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local createComponentPropertyForwarder = require(ReplicatedStorage.shared.util.createComponentPropertyForwarder)

local componentPropertyForwarder = createComponentPropertyForwarder({
	size = "size",
	position = "position",
	anchorPoint = "anchorPoint",
	visible = "visible",
	zIndex = "zIndex"
})

local function mapScreenToObject(position, p) -- 3 equivalent calls inferred from this helper
	local absolutePosition = p.AbsolutePosition
	local v = absolutePosition + p.AbsoluteSize

	return Vector2.new(
		Number.map(position.X, absolutePosition.X, v.X, 0, 1),
		Number.map(position.Y, absolutePosition.Y, v.Y, 0, 1)
	)
end

local createElement = Roact.createElement

local function Draggable(props, p)
	return createElement(Button, componentPropertyForwarder(props, {
		[Roact.Event.InputBegan] = p.useCallback(function(p2, instance)
			local v = instance.UserInputType == Enum.UserInputType.MouseButton1
			local v2 = instance.UserInputType == Enum.UserInputType.Touch

			if (v or v2) and instance.UserInputState == Enum.UserInputState.Begin then
				local v3 = mapScreenToObject(instance.Position, p2) -- inferred equivalent call

				if not props.onBegin or props.onBegin(v3) then
					props.onPosition(v3)

					local v4 = Maid.new()

					if v then
						v4:giveTask(UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement then
								local v5 = mapScreenToObject(input.Position, p2) -- inferred equivalent call
								props.onPosition(v5)
							end
						end))
					elseif v2 then
						v4:giveTask(instance:GetPropertyChangedSignal("Position"):Connect(function()
							local v5 = mapScreenToObject(instance.Position, p2) -- inferred equivalent call
							props.onPosition(v5)
						end))
					end

					v4:giveTask(instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if not Input.isActive(instance) then
							v4:clean()

							if props.onRelease then
								props.onRelease()
							end
						end
					end))
				end
			end
		end, { props.onBegin, props.onPosition, props.onRelease })
	}), props[Roact.Children])
end

return (hook(Draggable, { componentType = "PureComponent" }))