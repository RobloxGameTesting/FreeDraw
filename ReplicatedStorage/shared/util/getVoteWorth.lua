local ReplicatedStorage = game:GetService("ReplicatedStorage")

local isPro = require(ReplicatedStorage.shared.util.isPro)

local function getVoteWorth(data)
	local voteWorth = 1

	if data.AccountAge <= 3 then
		voteWorth *= 0.25
	elseif data.AccountAge <= 7 then
		voteWorth *= 0.5
	elseif data.AccountAge <= 14 then
		voteWorth *= 0.75
	end

	if data.DisplayName ~= data.Name then
		voteWorth *= 1.15
	end

	if isPro(data) then
		voteWorth *= 1.5
	end

	return voteWorth
end

return getVoteWorth