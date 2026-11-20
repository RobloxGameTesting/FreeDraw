local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local ContentStatus = require(ReplicatedStorage.shared.enum.ContentStatus)

local actionCreator = Rodux.makeActionCreator("userData/setStatus", function(status)
	return { status = status }
end)

local actionCreator2 = Rodux.makeActionCreator("userData/hide", function()
	return {}
end)

return {
	reducer = Rodux.combineReducers({
		status = Rodux.createReducer(ContentStatus.Loading, {
			[actionCreator.name] = function(_, p)
				return p.status
			end
		}),
		visible = Rodux.createReducer(true, {
			[actionCreator2.name] = function(): boolean
				return false
			end,
			[actionCreator.name] = function(p, p2)
				return p2.status == ContentStatus.Loading or p
			end
		})
	}),
	actions = { setStatus = actionCreator },
	thunks = {
		hideAfterDuration = function(duration)
			return function(object)
				task.delay(duration, function()
					object:dispatch(actionCreator2())
				end)
			end
		end
	}
}