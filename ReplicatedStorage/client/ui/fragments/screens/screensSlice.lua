local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local generateUniqueId = require(ReplicatedStorage.shared.util.generateUniqueId)

local v = { id = "base", name = "base", options = {} }

local actionCreator = Rodux.makeActionCreator("routing/pushRoute", function(name, options)
	return {
		id = generateUniqueId(15),
		name = name,
		options = options or {}
	}
end)

local actionCreator2 = Rodux.makeActionCreator("routing/popRoute", function()
	return {}
end)

return {
	reducer = Rodux.createReducer({}, {
		[actionCreator.name] = function(p, data)
			return Sift.List.push(p, { id = data.id, name = data.name, options = data.options })
		end,
		[actionCreator2.name] = function(p)
			return Sift.List.pop(p)
		end
	}),
	actions = { pushScreen = actionCreator, popScreen = actionCreator2 },
	selectors = {
		selectCurrentScreen = function(p)
			local screens = p.screens

			if #screens > 0 then
				return screens[#screens]
			end

			return v
		end
	}
}