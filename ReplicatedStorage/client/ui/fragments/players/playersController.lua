local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Promise = require(ReplicatedStorage.packages.Promise)

local Maid = require(ReplicatedStorage.shared.class.Maid)
local playersSlice = require(script.Parent.playersSlice)
local reportSlice = require(ReplicatedStorage.client.ui.fragments.report.reportSlice)
local containers = require(ReplicatedStorage.shared.containers)
local make = require(ReplicatedStorage.shared.util.make)

local drawing = containers.drawing
local v = make("Folder", { Name = "HiddenContainer", Parent = ReplicatedStorage })

local function setCharacterVisible(folder, p)
	for _, descendant in folder:GetDescendants() do
		if not (descendant:IsA("BasePart") or descendant:IsA("Decal")) then
			continue
		end

		local transparency = descendant:GetAttribute("transparency")

		if p and transparency then
			descendant:SetAttribute("transparency", nil)
			descendant.Transparency = transparency
		elseif not (p or transparency) then
			descendant:SetAttribute("transparency", descendant.Transparency)
			descendant.Transparency = 1
		end
	end
end

local function playersStatusController(object)
	local function onCoreEvents(p, p2, fn)
		local v2 = Maid.new()

		Promise.try(function()
			return { enable = StarterGui:GetCore(p).Event, disable = StarterGui:GetCore(p2).Event }
		end):andThen(function(p3)
			v2:giveTasks({
				p3.enable:Connect(function(p4)
					fn(p4, true)
				end),
				p3.disable:Connect(function(p4)
					fn(p4, false)
				end)
			})
		end)

		return v2
	end

	local v2 = Maid.new({
		onCoreEvents("PlayerFriendedEvent", "PlayerUnfriendedEvent", function(p, p2)
			object:dispatch(playersSlice.actions.setPlayerFriend(p.UserId, p2))
		end),
		onCoreEvents("PlayerBlockedEvent", "PlayerUnblockedEvent", function(p, p2)
			object:dispatch(playersSlice.actions.setPlayerBlocked(p.UserId, p2))
		end),
		onCoreEvents("PlayerMutedEvent", "PlayerUnmutedEvent", function(p, p2)
			object:dispatch(playersSlice.actions.setPlayerMuted(p.UserId, p2))
		end)
	})

	return function()
		v2:clean()
	end
end

local function playersHiddenController(object)
	local v2 = Maid.new({
		object.changed:connect(function(p, p2)
			local players = p.players
			local players2 = p2.players

			local target = reportSlice.selectors.selectTarget(p)
			local target2 = reportSlice.selectors.selectTarget(p2)

			task.spawn(function()
				if players ~= players2 or target ~= target2 then
					for _, player in players do
						local playerByUserId = Players:GetPlayerByUserId(player.id)
						local value = playerByUserId:WaitForChild("Trackers").Value
						local v2

						if target then
							v2 = target ~= playerByUserId
						else
							v2 = player.hidden
						end

						local parent = if v2 then v else drawing
						value.Parent = parent

						if playerByUserId.Character then
							setCharacterVisible(playerByUserId.Character, not v2)
						end
					end
				end
			end)
		end),
		Players.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function(character)
				local state = object:getState()
				local target = reportSlice.selectors.selectTarget(state)

				if target and target ~= player or state.players[player.UserId].hidden then
					setCharacterVisible(character, false)
				end
			end)
		end)
	})

	return function()
		v2:clean()
	end
end

local function playersAttributesController(object)
	local v2 = {}

	local function onPlayer(object2) -- 1 equivalent call inferred from this helper
		v2[object2] = object2.AttributeChanged:Connect(function()
			object:dispatch(playersSlice.actions.setPlayerAttributes(object2.UserId, object2:GetAttributes()))
		end)
	end

	for _, v3 in Players:GetPlayers() do
		onPlayer(v3) -- inferred equivalent call
	end

	local v3 = Maid.new({
		Players.PlayerAdded:Connect(onPlayer),
		Players.PlayerRemoving:Connect(function(player)
			if v2[player] then
				v2[player]:Disconnect()
				v2[player] = nil
			end
		end)
	})

	return function()
		v3:clean()

		for _, connection in v2 do
			connection:Disconnect()
		end
	end
end

local function playersController(object)
	local v2 = Maid.new({
		Players.PlayerAdded:Connect(function(player)
			object:dispatch(playersSlice.actions.addPlayer(
				player.UserId,
				player.Name,
				player.DisplayName,
				player.HasVerifiedBadge
			))
		end),
		Players.PlayerRemoving:Connect(function(player)
			object:dispatch(playersSlice.actions.removePlayer(player.UserId))
		end),
		playersStatusController(object),
		playersHiddenController(object),
		playersAttributesController(object)
	})

	return function()
		v2:clean()
	end
end

return playersController