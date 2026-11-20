local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local remotes = require(ReplicatedStorage.shared.remotes)
local VotekickVote = require(ReplicatedStorage.shared.enum.VotekickVote)
local VotekickStatus = require(ReplicatedStorage.shared.enum.VotekickStatus)
local generateUniqueId = require(ReplicatedStorage.shared.util.generateUniqueId)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local dialogsSlice = require(ReplicatedStorage.client.ui.fragments.dialogs.dialogsSlice)
local toastsSlice = require(ReplicatedStorage.client.ui.fragments.toasts.toastsSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local VotekickReason = require(ReplicatedStorage.shared.enum.VotekickReason)
local config = require(ReplicatedStorage.shared.data.config)

local requestVotekick = remotes.Client:Get("requestVotekick")
local setVotekickVote = remotes.Client:Get("setVotekickVote")

local LocalPlayer = Players.LocalPlayer

local actionCreator = Rodux.makeActionCreator("votekick/setVotekick", function(data)
	return {
		id = generateUniqueId(),
		time = os.clock() - data.timeElapsed,
		source = data.source,
		target = data.target,
		reason = VotekickReason[data.reason],
		progress = data.progress
	}
end)

local actionCreator2 = Rodux.makeActionCreator("votekick/updateVotekick", function(progress)
	return { progress = progress }
end)

local actionCreator3 = Rodux.makeActionCreator("votekick/setVotekickVote", function(vote)
	assert(vote ~= VotekickVote.None, "Vote can't be None")

	return { vote = vote }
end)

local actionCreator4 = Rodux.makeActionCreator("votekick/endVotekick", function(p)
	return { result = p }
end)

local actionCreator5 = Rodux.makeActionCreator("votekick/closeVotekick", function()
	return {}
end)

local actionCreator6 = Rodux.makeActionCreator("votekick/expandVotekick", function()
	return {}
end)

return {
	reducer = Rodux.createReducer(nil, {
		[actionCreator.name] = function(_, data)
			return {
				id = data.id,
				source = data.source,
				target = data.target,
				reason = data.reason,
				vote = VotekickVote.None,
				status = VotekickStatus.Pending,
				progress = data.progress,
				time = data.time,
				visible = true,
				expanded = false
			}
		end,
		[actionCreator2.name] = function(p, p2)
			return Sift.Dictionary.set(p, "progress", p2.progress)
		end,
		[actionCreator3.name] = function(p, p2)
			return Sift.Dictionary.set(p, "vote", p2.vote)
		end,
		[actionCreator4.name] = function(p, p2)
			local set = Sift.Dictionary.set
			local v

			if p2.result then
				v = VotekickStatus.Kicked
			else
				v = VotekickStatus.NotKicked
			end

			return set(p, "status", v)
		end,
		[actionCreator5.name] = function(p)
			return Sift.Dictionary.set(p, "visible", false)
		end,
		[actionCreator6.name] = function(p)
			return Sift.Dictionary.set(p, "expanded", true)
		end
	}),
	middleware = function(callback, p)
		return function(data)
			if
				data.type == dialogsSlice.actions.interact.name
				and data.id == "votekick"
				and data.buttonId == "confirm"
				and data.state.reason
			then
				local playerByUserId = Players:GetPlayerByUserId(data.context.id)
				local reason = data.state.reason
				p:dispatch(function()
					requestVotekick:CallServerAsync(playerByUserId, reason.name)
				end)
			end

			return callback(data)
		end
	end,
	actions = {
		startVotekick = actionCreator,
		updateVotekick = actionCreator2,
		setVotekickVote = actionCreator3,
		endVotekick = actionCreator4,
		closeVotekick = actionCreator5,
		expandVotekick = actionCreator6
	},
	thunks = {
		hideVotekickAfterDuration = function(duration)
			return function(object)
				local votekick = object:getState().votekick
				task.delay(duration, function()
					if object:getState().votekick.id == votekick.id then
						object:dispatch(actionCreator5())
					end
				end)
			end
		end,
		votekickDialog = function(id)
			return function(object)
				if object:getState().players[LocalPlayer.UserId].timeSpent >= config.votekick.minimumHours * 3600 then
					object:dispatch(screensSlice.actions.pushScreen("dialog", {
						id = "votekick",
						title = Localization.String.new("votekick.dialog.votekick.title"),
						description = Localization.String.new("votekick.dialog.votekick.description", {
							player = object:getState().players[id].name
						}),
						embeds = {
							{
								id = "reason",
								type = "dropdown",
								options = {
									placeholder = {
										text = Localization.String.new("votekick.dialog.votekick.embed.reason.placeholder")
									},
									items = Sift.List.map({
										VotekickReason.Scribbling,
										VotekickReason.Griefing,
										VotekickReason.HateSpeech,
										VotekickReason.Harassment,
										VotekickReason.Spamming,
										VotekickReason.Tracing,
										VotekickReason.Hacking,
										VotekickReason.FalseVotekicking,
										VotekickReason.Other
									}, function(id2)
										return {
											id = id2,
											text = Localization.String.new(("votekick.reason.%s"):format(id2.value))
										}
									end)
								}
							}
						},
						buttons = {
							{
								id = "cancel",
								text = Localization.String.new("votekick.dialog.votekick.button.cancel")
							},
							{
								id = "confirm",
								text = Localization.String.new("votekick.dialog.votekick.button.votekick"),
								style = ButtonStyle.Filled
							}
						},
						context = { id = id }
					}))
				else
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("votekick.toast.notEnoughHours", {
							hours = config.votekick.minimumHours
						}),
						icon = "alert"
					}))
				end
			end
		end,
		requestVotekickAsync = function(p, p2)
			return function()
				requestVotekick:CallServerAsync(p, p2.name)
			end
		end,
		setVotekickVoteAsync = function(p)
			assert(p ~= VotekickVote.None, "Vote can't be None")

			return function(object)
				object:dispatch(actionCreator3(p))
				setVotekickVote:SendToServer(p == VotekickVote.Kick)
			end
		end
	}
}