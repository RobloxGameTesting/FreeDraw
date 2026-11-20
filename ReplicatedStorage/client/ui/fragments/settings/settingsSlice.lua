local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local settings = require(ReplicatedStorage.shared.data.settings)
local remotes = require(ReplicatedStorage.shared.remotes)
local Response = require(ReplicatedStorage.shared.lib.Response)

local getSettings = remotes.Client:Get("getSettings")
local setSetting = remotes.Client:Get("setSetting")

local actionCreator = Rodux.makeActionCreator("settings/set", function(p, p2)
	return { key = p, value = p2 }
end)

local actionCreator2 = Rodux.makeActionCreator("settings/sync", function(p)
	return { data = p }
end)

local function fetchSettingsAsync()
	return function(object)
		getSettings:CallServerAsync():andThen(Response.promisify):andThen(function(p)
			object:dispatch(actionCreator2(p))
		end)
	end
end

return {
	reducer = Rodux.createReducer(nil, {
		[actionCreator.name] = function(p, p2)
			if p then
				return Sift.Dictionary.set(p, p2.key, p2.value)
			end

			return p
		end,
		[actionCreator2.name] = function(_, p)
			return p.data
		end
	}),
	middleware = function(callback, object)
		return function(data)
			if data.type == "init" then
				object:dispatch(function(object2)
					getSettings:CallServerAsync():andThen(Response.promisify):andThen(function(p)
						object2:dispatch(actionCreator2(p))
					end)
				end)
			elseif data.type == actionCreator.name then
				setSetting:SendToServer(data.key, data.value)
			end

			return callback(data)
		end
	end,
	actions = { set = actionCreator, sync = actionCreator2 },
	selectors = {
		selectSetting = function(p, p2)
			if p.settings then
				return p.settings[p2]
			end

			return settings[p2].default
		end
	}
}