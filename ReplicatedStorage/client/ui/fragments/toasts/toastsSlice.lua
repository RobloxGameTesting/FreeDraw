local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local generateUniqueId = require(ReplicatedStorage.shared.util.generateUniqueId)

local v = { duration = 10 }

local actionCreator = Rodux.makeActionCreator("toasts/createToast", function(id, options)
	return { id = id, options = options }
end)

local actionCreator2 = Rodux.makeActionCreator("toasts/hideToast", function(id)
	return { id = id }
end)

local actionCreator3 = Rodux.makeActionCreator("toasts/deleteToast", function(id)
	return { id = id }
end)

return {
	reducer = Rodux.createReducer({}, {
		[actionCreator.name] = function(p, p2)
			return Sift.List.unshift(p, { id = p2.id, visible = true, options = p2.options })
		end,
		[actionCreator2.name] = function(p, p2)
			return Sift.List.map(p, function(p3)
				if p3.id == p2.id then
					return Sift.Dictionary.join(p3, { visible = false })
				end

				return p3
			end)
		end,
		[actionCreator3.name] = function(p, p2)
			return Sift.List.filter(p, function(p3): boolean
				return p3.id ~= p2.id
			end)
		end
	}),
	actions = {
		createToast = actionCreator,
		hideToast = actionCreator2,
		deleteToast = actionCreator3
	},
	thunks = {
		showToast = function(p)
			local joined = Sift.Dictionary.join(v, p)

			return function(object)
				local v2 = generateUniqueId(15)
				object:dispatch(actionCreator(v2, joined))
				task.delay(joined.duration, function()
					object:dispatch(actionCreator2(v2, joined))
				end)
			end
		end
	}
}