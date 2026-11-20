local parent = script.Parent.Parent
require(parent.Types)

local function toSet(list)
	local set = {}

	for _, item in ipairs(list) do
		set[item] = true
	end

	return set
end

return toSet