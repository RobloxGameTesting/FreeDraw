local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local remotes = require(ReplicatedStorage.shared.remotes)
local Response = require(ReplicatedStorage.shared.lib.Response)
local toastsSlice = require(ReplicatedStorage.client.ui.fragments.toasts.toastsSlice)
local ClaimError = require(ReplicatedStorage.shared.enum.error.ClaimError)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local getClaims = remotes.Client:Get("getClaims")
local setClaim = remotes.Client:Get("setClaim")
local deleteClaim = remotes.Client:Get("deleteClaim")

local LocalPlayer = Players.LocalPlayer

local actionCreator = Rodux.makeActionCreator("claims/setClaim", function(id, claim)
	return { id = id, claim = claim }
end)

local actionCreator2 = Rodux.makeActionCreator("claims/deleteClaim", function(id)
	return { id = id }
end)

return {
	reducer = Rodux.createReducer({}, {
		[actionCreator.name] = function(p, p2)
			return Sift.Dictionary.set(p, p2.id, p2.claim)
		end,
		[actionCreator2.name] = function(p, p2)
			return Sift.Dictionary.removeKey(p, p2.id)
		end
	}),
	middleware = function(callback, object)
		return function(p)
			if p.type == "init" then
				object:dispatch(function(object2)
					getClaims:CallServerAsync():andThen(Response.promisify):andThen(function(items)
						for _, item in items do
							object2:dispatch(actionCreator(item.player.UserId, item.claim))
						end
					end)
				end)
			end

			return callback(p)
		end
	end,
	actions = { setClaim = actionCreator, deleteClaim = actionCreator2 },
	thunks = {
		claimErrorToast = function(p)
			return function(object)
				local v = ClaimError[p]
				local showToast = toastsSlice.thunks.showToast
				local text

				if v then
					text = Localization.String.new(("claim.toast.error.%s"):format(v.value))
				else
					text = p
				end

				object:dispatch(showToast({ text = text, icon = "alert" }))
			end
		end,
		syncClaimsAsync = function()
			return function(object)
				getClaims:CallServerAsync():andThen(Response.promisify):andThen(function(items)
					for _, item in items do
						object:dispatch(actionCreator(item.player.UserId, item.claim))
					end
				end)
			end
		end,
		setClaimAsync = function(p)
			return function(object)
				setClaim:CallServerAsync(p):andThen(Response.promisify):andThen(function()
					object:dispatch(actionCreator(LocalPlayer.UserId, p))
				end):catch(function(p2)
					object:dispatch(function(object2)
						local v = ClaimError[p2]
						local showToast = toastsSlice.thunks.showToast
						local text

						if v then
							text = Localization.String.new(("claim.toast.error.%s"):format(v.value))
						else
							text = p2
						end

						object2:dispatch(showToast({ text = text, icon = "alert" }))
					end)
				end)
			end
		end,
		deleteClaimAsync = function()
			return function(object)
				object:dispatch(actionCreator2(LocalPlayer.UserId))
				deleteClaim:CallServerAsync():andThen(Response.promisify):andThen(function()
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("claim.toast.deleteClaim"),
						icon = "flag"
					}))
				end)
			end
		end
	}
}