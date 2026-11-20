local ReplicatedStorage = game:GetService("ReplicatedStorage")

local config = require(ReplicatedStorage.shared.data.config)

local function getLevelInt(p) -- 2 equivalent calls inferred from this helper
	return #config.group.levels - table.find(config.group.levels, p) + 1 or -1
end

local function getRoleLevel(p) -- 1 equivalent call inferred from this helper
	if p then
		return config.group.roles[p].level
	end

	return "PLAYER"
end

local Group = {}
Group.getLevelInt = getLevelInt

function Group.getRoleRank(p)
	for k, assignment in config.group.assignments do
		if assignment == p then
			return k
		end
	end

	return -1
end

Group.getRoleLevel = getRoleLevel

function Group.getRoleTrusted(p)
	if p then
		return config.group.roles[p].trusted
	end

	return false
end

function Group.doesRoleHaveLevel(p, p2): boolean
	return getLevelInt(getRoleLevel(p)) >= getLevelInt(p2) -- inferred equivalent call
end

return Group