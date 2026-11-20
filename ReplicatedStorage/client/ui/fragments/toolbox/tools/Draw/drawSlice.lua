local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local Stabilizer = require(ReplicatedStorage.shared.lib.Stabilizer)
local StabilizerType = require(ReplicatedStorage.shared.enum.StabilizerType)
local remotes = require(ReplicatedStorage.shared.remotes)
local Response = require(ReplicatedStorage.shared.lib.Response)
local optionsSlice = require(ReplicatedStorage.client.ui.fragments.options.optionsSlice)
local toastsSlice = require(ReplicatedStorage.client.ui.fragments.toasts.toastsSlice)
local ToolboxError = require(ReplicatedStorage.shared.enum.error.ToolboxError)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local config = require(ReplicatedStorage.shared.data.config)
local isPrivateServer = require(ReplicatedStorage.shared.util.isPrivateServer)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createLine = remotes.Client:Get("createLine")

local actionCreator = Rodux.makeActionCreator("toolbox/draw/setOptions", function(p)
	return p
end)

local actionCreator2 = Rodux.makeActionCreator("toolbox/draw/createLine", function(id, position)
	return { id = id, position = position }
end)

local actionCreator3 = Rodux.makeActionCreator("toolbox/draw/addPointToLine", function(id, position)
	return { id = id, position = position }
end)

local actionCreator4 = Rodux.makeActionCreator("toolbox/draw/deleteLine", function(id)
	return { id = id }
end)

local actionCreator5 = Rodux.makeActionCreator("toolbox/draw/clearLines", function()
	return {}
end)

return {
	reducer = Rodux.combineReducers({
		lines = Rodux.createReducer({}, {
			[actionCreator2.name] = function(p, p2)
				return Sift.Dictionary.set(p, p2.id, { p2.position })
			end,
			[actionCreator3.name] = function(p, p2)
				return Sift.Dictionary.update(p, p2.id, function(list)
					if #list < config.tools.draw.limit or isPrivateServer() then
						return Sift.List.push(list, p2.position)
					end

					return list
				end)
			end,
			[actionCreator4.name] = function(p, p2)
				return Sift.Dictionary.removeKey(p, p2.id)
			end,
			[actionCreator5.name] = function()
				return {}
			end
		}),
		options = Rodux.createReducer({
			stabilizerType = StabilizerType.None,
			stabilizerIntensity = 0.5
		}, {
			[actionCreator.name] = function(p, p2)
				return Sift.Dictionary.join(p, {
					stabilizerType = p2.stabilizerType,
					stabilizerIntensity = p2.stabilizerIntensity
				})
			end
		})
	}),
	actions = {
		setOptions = actionCreator,
		createLine = actionCreator2,
		addPointToLine = actionCreator3,
		deleteLine = actionCreator4,
		clearLines = actionCreator5
	},
	thunks = {
		drawErrorToast = function(p)
			return function(object)
				local v = ToolboxError[p]
				local showToast = toastsSlice.thunks.showToast
				local text

				if v then
					text = Localization.String.new(("toolbox.draw.toast.error.%s"):format(v.value))
				else
					text = p
				end

				object:dispatch(showToast({ text = text, icon = "alert" }))
			end
		end,
		finishLineAsync = function(p)
			return function(object)
				local state = object:getState()
				local tool = state.toolbox.tools[ToolType.Draw]

				local selectedLayer = state.layers.selectedLayer
				local line = tool.lines[p]
				local options = optionsSlice.selectors.selectOptions(state)

				local stabilizerType = tool.options.stabilizerType
				local stabilizerIntensity = tool.options.stabilizerIntensity

				createLine:CallServerAsync(
					selectedLayer,
					options,
					(Stabilizer.stabilize(line, stabilizerType, stabilizerIntensity))
				):andThen(Response.promisify):catch(function(text)
					local showToast = toastsSlice.thunks.showToast

					if ToolboxError[text] then
						text = Localization.String.new(("toolbox.toast.error.%s"):format(ToolboxError[text].value))
					end

					object:dispatch(showToast({ text = text, icon = "alert" }))
				end):finally(function()
					object:dispatch(actionCreator4(p))
					object:flush()
				end)
			end
		end
	}
}