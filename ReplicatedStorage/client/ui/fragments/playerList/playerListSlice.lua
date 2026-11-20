local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local playersSlice = require(ReplicatedStorage.client.ui.fragments.players.playersSlice)
local platformSlice = require(ReplicatedStorage.client.ui.fragments.platform.platformSlice)
local PlatformType = require(ReplicatedStorage.shared.enum.PlatformType)

local actionCreator = Rodux.makeActionCreator("playerList/setOpen", function(open)
	return { open = open }
end)

local actionCreator2 = Rodux.makeActionCreator("playerList/toggleOpen", function()
	return {}
end)

local actionCreator3 = Rodux.makeActionCreator("playerList/se", function(id)
	return { id = id }
end)

return {
	reducer = Rodux.combineReducers({
		open = Rodux.createReducer(true, {
			[actionCreator.name] = function(_, p)
				return p.open
			end,
			[actionCreator2.name] = function(p): boolean
				return not p
			end
		}),
		selectedPlayer = Rodux.createReducer(nil, {
			[actionCreator3.name] = function(p, p2)
				return if p2.id ~= p then p2.id else nil
			end,
			[playersSlice.actions.removePlayer.name] = function(p, p2)
				return if p2.id ~= p then p else nil
			end
		})
	}),
	middleware = function(callback, object)
		return function(p)
			if p.type == platformSlice.actions.setPlatform.name and p.platformType == PlatformType.Phone then
				object:dispatch(actionCreator(false))
			end

			return callback(p)
		end
	end,
	actions = {
		setOpen = actionCreator,
		toggleOpen = actionCreator2,
		selectPlayer = actionCreator3
	}
}