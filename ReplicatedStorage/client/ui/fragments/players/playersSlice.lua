local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)
local Promise = require(ReplicatedStorage.packages.Promise)

local LocalPlayer = Players.LocalPlayer

local actionCreator = Rodux.makeActionCreator("players/addPlayer", function(id, name, displayName, verified, accountAge)
	return {
		id = id,
		name = name,
		displayName = displayName,
		verified = verified,
		accountAge = accountAge
	}
end)

local actionCreator2 = Rodux.makeActionCreator("players/removePlayer", function(id)
	return { id = id }
end)

local actionCreator3 = Rodux.makeActionCreator("players/setPlayerFriend", function(id, friend)
	return { id = id, friend = friend }
end)

local actionCreator4 = Rodux.makeActionCreator("players/setPlayerBlocked", function(id, blocked)
	return { id = id, blocked = blocked }
end)

local actionCreator5 = Rodux.makeActionCreator("players/setPlayerMuted", function(id, muted)
	return { id = id, muted = muted }
end)

local actionCreator6 = Rodux.makeActionCreator("players/setPlayerAttributes", function(id, attributes)
	return { id = id, attributes = attributes }
end)

local actionCreator7 = Rodux.makeActionCreator("players/setPlayerHidden", function(id, hidden)
	return { id = id, hidden = hidden }
end)

return {
	reducer = Rodux.createReducer({}, {
		[actionCreator.name] = function(p, data)
			return Sift.Dictionary.set(p, data.id, {
				id = data.id,
				name = data.name,
				displayName = data.displayName,
				verified = data.verified,
				accountAge = data.accountAge,
				friend = false,
				blocked = false,
				muted = false,
				role = "player",
				proStart = 0,
				proExpiry = 0,
				timeSpent = 0,
				hidden = false,
				hideRole = false,
				hideTime = false,
				hidePro = false
			})
		end,
		[actionCreator2.name] = function(p, p2)
			if p2.id == LocalPlayer.UserId then
				return p
			end

			return Sift.Dictionary.removeKey(p, p2.id)
		end,
		[actionCreator3.name] = function(p, p2)
			return Sift.Dictionary.update(p, p2.id, function(p3)
				return Sift.Dictionary.set(p3, "friend", p2.friend)
			end)
		end,
		[actionCreator4.name] = function(p, p2)
			return Sift.Dictionary.update(p, p2.id, function(p3)
				return Sift.Dictionary.set(p3, "blocked", p2.blocked)
			end)
		end,
		[actionCreator5.name] = function(p, p2)
			return Sift.Dictionary.update(p, p2.id, function(p3)
				return Sift.Dictionary.set(p3, "muted", p2.muted)
			end)
		end,
		[actionCreator6.name] = function(p, p2)
			return Sift.Dictionary.update(p, p2.id, function(p3)
				return Sift.Dictionary.join(p3, p2.attributes)
			end)
		end,
		[actionCreator7.name] = function(p, p2)
			return Sift.Dictionary.update(p, p2.id, function(p3)
				return Sift.Dictionary.set(p3, "hidden", p2.hidden)
			end)
		end
	}),
	middleware = function(callback, object)
		return function(p)
			if p.type == "init" then
				for _, v in Players:GetPlayers() do
					object:dispatch(actionCreator(v.UserId, v.Name, v.DisplayName, v.HasVerifiedBadge, v.AccountAge))
				end
			elseif p.type == actionCreator.name then
				local playerByUserId = Players:GetPlayerByUserId(p.id)

				task.defer(function()
					local v = playerByUserId
					object:dispatch(function(object2)
						Promise.try(function()
							return LocalPlayer:IsFriendsWith(v.UserId)
						end):andThen(function(p2)
							object2:dispatch(actionCreator3(v.UserId, p2))
						end)
					end)
					object:dispatch(actionCreator6(p.id, playerByUserId:GetAttributes()))
				end)
			end

			return callback(p)
		end
	end,
	actions = {
		addPlayer = actionCreator,
		removePlayer = actionCreator2,
		setPlayerFriend = actionCreator3,
		setPlayerBlocked = actionCreator4,
		setPlayerMuted = actionCreator5,
		setPlayerAttributes = actionCreator6,
		setPlayerHidden = actionCreator7
	},
	thunks = {
		fetchPlayerFriendAsync = function(p)
			return function(object)
				Promise.try(function()
					return LocalPlayer:IsFriendsWith(p.UserId)
				end):andThen(function(p2)
					object:dispatch(actionCreator3(p.UserId, p2))
				end)
			end
		end
	}
}