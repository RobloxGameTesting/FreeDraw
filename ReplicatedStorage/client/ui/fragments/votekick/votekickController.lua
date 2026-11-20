local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = require(ReplicatedStorage.shared.remotes)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local votekickSlice = require(script.Parent.votekickSlice)

local startVotekick = remotes.Client:Get("startVotekick")
local updateVotekick = remotes.Client:Get("updateVotekick")
local endVotekick = remotes.Client:Get("endVotekick")

local function votekickController(object)
	local v = Maid.new({
		startVotekick:Connect(function(p)
			object:dispatch(votekickSlice.actions.startVotekick(p))
		end),
		updateVotekick:Connect(function(p)
			object:dispatch(votekickSlice.actions.updateVotekick(p))
		end),
		endVotekick:Connect(function(p)
			object:dispatch(votekickSlice.actions.endVotekick(p))
			object:dispatch(votekickSlice.thunks.hideVotekickAfterDuration(5))
		end)
	})

	return function()
		v:clean()
	end
end

return votekickController