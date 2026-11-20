local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = require(ReplicatedStorage.shared.remotes)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local claimsSlice = require(script.Parent.claimsSlice)

local claimSet = remotes.Client:Get("claimSet")
local claimDelete = remotes.Client:Get("claimDelete")

local function claimsController(object)
	local v = Maid.new({
		claimSet:Connect(function(p, p2)
			object:dispatch(claimsSlice.actions.setClaim(p.UserId, p2))
		end),
		claimDelete:Connect(function(p)
			object:dispatch(claimsSlice.actions.deleteClaim(p.UserId))
		end)
	})

	return function()
		v:clean()
	end
end

return claimsController