local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)

return {
	reducer = nil,
	middleware = function(callback, object)
		return function(p)
			if p.type == "init" then
				if RunService:IsStudio() then
					print("Skipping rules screen")
				else
					object:dispatch(screensSlice.actions.pushScreen("rules"))
				end
			end

			return callback(p)
		end
	end
}