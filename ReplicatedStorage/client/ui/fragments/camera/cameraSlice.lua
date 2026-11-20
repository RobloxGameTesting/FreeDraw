local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local Vector = require(ReplicatedStorage.shared.lib.Vector)

local _ = { min = 4, max = 110 }
local vector2 = Vector2.new(-1, 1)

local LocalPlayer = Players.LocalPlayer

local v = { position = Vector2.new(0, 0), rotation = 0, zoom = 0 }

local vector2_2 = Vector2.new(0, 0)

local function getInitialPosition()
	local primaryPartCFrame = LocalPlayer.Character:GetPrimaryPartCFrame()
	return Vector2.new(primaryPartCFrame.X, primaryPartCFrame.Z)
end

local actionCreator = Rodux.makeActionCreator("camera/setEnabled", function(enabled)
	return { enabled = enabled }
end)

local actionCreator2 = Rodux.makeActionCreator("camera/toggleEnabled", function()
	return {}
end)

local actionCreator3 = Rodux.makeActionCreator("camera/input", function(p, p2)
	return {
		frame = Sift.Dictionary.join(v, p),
		anchor = p2 or vector2_2
	}
end)

local actionCreator4 = Rodux.makeActionCreator("camera/move", function(position)
	return { position = position }
end)

local actionCreator5 = Rodux.makeActionCreator("camera/flip", function()
	return {}
end)

return {
	reducer = Rodux.combineReducers({
		enabled = Rodux.createReducer(false, {
			[actionCreator.name] = function(_, p)
				return p.enabled
			end,
			[actionCreator2.name] = function(p): boolean
				return not p
			end
		}),
		state = Rodux.createReducer({
			position = Vector2.new(0, 0),
			rotation = 0,
			zoom = 10,
			flip = false
		}, {
			[actionCreator3.name] = function(data, p)
				local frame = p.frame
				local anchor = p.anchor

				local position = data.position
				local rotation = data.rotation
				local zoom = data.zoom
				local flip = data.flip

				local position2 = frame.position
				local rotation2 = frame.rotation
				local zoom2 = frame.zoom
				local v2

				if flip then
					position2 *= vector2
					rotation2 = -rotation2
					v2 = anchor * vector2
				else
					v2 = anchor
				end

				local v3 = position - Vector.rotate(v2, rotation) + Vector.rotate(v2, rotation + rotation2)
				local rotation3 = (rotation + rotation2) % 6.283185307179586

				local zoom3 = math.clamp(zoom + zoom2, 4, 110)
				local v4 = zoom3 - zoom

				return {
					position = v3 + Vector.rotate(-(anchor / zoom3) * v4, rotation3) + Vector.rotate(position2, rotation3),
					rotation = rotation3,
					zoom = zoom3,
					flip = flip
				}
			end,
			[actionCreator4.name] = function(p, p2)
				return Sift.Dictionary.set(p, "position", p2.position)
			end,
			[actionCreator5.name] = function(p)
				return Sift.Dictionary.set(p, "flip", not p.flip)
			end
		})
	}),
	middleware = function(callback, object)
		return function(p)
			if p.type == actionCreator.name or p.type == actionCreator2.name then
				object:dispatch(actionCreator4(getInitialPosition()))
			end

			return callback(p)
		end
	end,
	actions = {
		setEnabled = actionCreator,
		toggleEnabled = actionCreator2,
		input = actionCreator3,
		move = actionCreator4,
		flip = actionCreator5
	}
}