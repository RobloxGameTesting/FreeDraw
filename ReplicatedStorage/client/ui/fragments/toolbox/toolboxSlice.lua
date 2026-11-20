local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local cameraSlice = require(ReplicatedStorage.client.ui.fragments.camera.cameraSlice)
local screenshotSlice = require(ReplicatedStorage.client.ui.fragments.screenshot.screenshotSlice)
local tools = require(script.Parent.tools)

local actionCreator = Rodux.makeActionCreator("toolbox/setTool", function(tool)
	return { tool = tool }
end)

return {
	reducer = Rodux.combineReducers({
		selectedTool = Rodux.createReducer(nil, {
			[actionCreator.name] = function(p, p2)
				return if p ~= p2.tool then p2.tool else nil
			end,
			[cameraSlice.actions.setEnabled.name] = function(): nil
				return nil
			end,
			[cameraSlice.actions.toggleEnabled.name] = function(): nil
				return nil
			end,
			[screenshotSlice.actions.setScreenshot.name] = function(): nil
				return nil
			end,
			[screenshotSlice.actions.toggleScreenshot.name] = function(): nil
				return nil
			end
		}),
		tools = Rodux.combineReducers(Sift.Dictionary.map(tools, function(p)
			return if p.slice then p.slice.reducer else nil
		end))
	}),
	actions = { setTool = actionCreator }
}