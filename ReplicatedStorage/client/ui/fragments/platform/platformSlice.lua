local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local PlatformType = require(ReplicatedStorage.shared.enum.PlatformType)
local PointerType = require(ReplicatedStorage.shared.enum.PointerType)

local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

local actionCreator = Rodux.makeActionCreator("platform/setPlatform", function(platformType)
	return { platformType = platformType }
end)

local actionCreator2 = Rodux.makeActionCreator("platform/setOrientation", function(orientation)
	return { orientation = orientation }
end)

local actionCreator3 = Rodux.makeActionCreator("platform/setPointer", function(pointerType)
	return { pointerType = pointerType }
end)

return {
	reducer = Rodux.combineReducers({
		type = Rodux.createReducer(PlatformType.Desktop, {
			[actionCreator.name] = function(_, p)
				return p.platformType
			end
		}),
		orientation = Rodux.createReducer(Enum.ScreenOrientation.LandscapeSensor, {
			[actionCreator2.name] = function(_, p)
				return p.orientation
			end
		}),
		pointer = Rodux.createReducer(PointerType.Mouse, {
			[actionCreator3.name] = function(_, p)
				return p.pointerType
			end
		})
	}),
	middleware = function(callback)
		return function(p)
			if p.type == actionCreator2.name then
				playerGui.ScreenOrientation = p.orientation
			end

			return callback(p)
		end
	end,
	actions = {
		setPlatform = actionCreator,
		setOrientation = actionCreator2,
		setPointer = actionCreator3
	}
}