local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = require(ReplicatedStorage.shared.remotes)
local userDataSlice = require(script.Parent.userDataSlice)
local ContentStatus = require(ReplicatedStorage.shared.enum.ContentStatus)

local updateUserDataStatus = remotes.Client:Get("updateUserDataStatus")

local function userDataController(object)
	local connection = updateUserDataStatus:Connect(function(p)
		local v = ContentStatus[p]

		object:dispatch(userDataSlice.actions.setStatus(v))

		if v == ContentStatus.Loaded then
			object:dispatch(userDataSlice.thunks.hideAfterDuration(2))
		end
	end)

	return function()
		connection:Disconnect()
	end
end

return userDataController