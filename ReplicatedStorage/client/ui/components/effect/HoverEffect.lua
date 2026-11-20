local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Collision = require(ReplicatedStorage.shared.lib.Collision)
local Input = require(ReplicatedStorage.shared.lib.Input)
local Maid = require(ReplicatedStorage.shared.class.Maid)

local createElement = Roact.createElement
local function isObjectVisible(parent)
	if parent:IsA("GuiObject") and not parent.Visible or parent:IsA("LayerCollector") and not parent.Enabled then
		return false
	end

	if parent.Parent then
		return isObjectVisible(parent.Parent)
	end

	return true
end

local function isPointVisible(p, guiObject)
	if not (guiObject:IsA("GuiObject") and guiObject.ClipsDescendants) then
		return true
	end

	if isPointVisible(p, guiObject.Parent) then
		return Collision.isPointWithinObject(p, guiObject)
	end

	return false
end

local function mapRelative(p, p2) -- 1 equivalent call inferred from this helper
	return (p - p2.AbsolutePosition) / p2.AbsoluteSize
end

local function HoverEffect(p, props)
	local v = props.useValue(0)
	local v2 = props.useValue(true)

	props.useEffect(function()
		return function()
			v2.value = false
		end
	end, {})

	local v3 = props.useCallback(function()
		if v2.value then
			v.value += 1
			p.onHover(v.value > 0)
		end
	end, { p.onHover })

	local v4 = props.useCallback(function()
		if v2.value then
			v.value -= 1
			p.onHover(v.value > 0)
		end
	end, { p.onHover })

	return createElement(Container, Sift.Dictionary.join(p, {
		[Roact.Event.InputBegan] = props.useCallback(function(p2, instance)
			local v5 = instance.UserInputType == Enum.UserInputType.MouseMovement
			local v6 = instance.UserInputType == Enum.UserInputType.Touch

			if v5 or v6 then
				local flag = false

				local function attemptIncrementCount() -- 1 equivalent call inferred from this helper
					if not flag then
						v3()
						flag = true
					end
				end

				local function attemptDecrementCount() -- 3 equivalent calls inferred from this helper
					if flag then
						v4()
						flag = false
					end
				end

				local v7 = nil

				local function check(vector2)
					if Collision.isPointWithinObject(vector2, p2) then
						local instance2 = p2
						local v8

						if
							instance2:IsA("GuiObject") and not instance2.Visible
							or instance2:IsA("LayerCollector") and not instance2.Enabled
						then
							v8 = false
						else
							v8 = not instance2.Parent or isObjectVisible(instance2.Parent)
						end

						if v8 then
							local guiObject = p2
							local v9

							if guiObject:IsA("GuiObject") and guiObject.ClipsDescendants then
								if isPointVisible(vector2, guiObject.Parent) then
									v9 = Collision.isPointWithinObject(vector2, guiObject)
								else
									v9 = false
								end
							else
								v9 = true
							end

							if v9 then
								if p.shape and not p.shape(mapRelative(vector2, p2)) then -- inferred equivalent call
									attemptDecrementCount() -- inferred equivalent call
									return
								end

								attemptIncrementCount() -- inferred equivalent call
								return
							end
						end
					end

					v7:clean()
					attemptDecrementCount() -- inferred equivalent call
				end

				local new = Maid.new
				local heartbeatConnection = RunService.Heartbeat:Connect(function()
					check(Vector2.new(instance.Position.X, instance.Position.Y))
				end)
				local v8

				if v6 then
					v8 = instance:GetPropertyChangedSignal("UserInputState"):Connect(function()
						if not Input.isActive(instance) then
							v7:clean()
							attemptDecrementCount() -- inferred equivalent call
						end
					end)
				end

				v7 = new({ heartbeatConnection, v8 })

				check(Vector2.new(instance.Position.X, instance.Position.Y))
			end
		end, { v3, v4, p.shape })
	}))
end

return (hook(HoverEffect, {
	componentType = "PureComponent",
	defaultProps = { size = UDim2.fromScale(1, 1) }
}))