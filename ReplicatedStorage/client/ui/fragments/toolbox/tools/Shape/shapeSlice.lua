local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local remotes = require(ReplicatedStorage.shared.remotes)
local GeometryType = require(ReplicatedStorage.shared.enum.GeometryType)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)
local optionsSlice = require(ReplicatedStorage.client.ui.fragments.options.optionsSlice)
local getCameraRotation = require(ReplicatedStorage.client.ui.fragments.camera.getCameraRotation)
local config = require(ReplicatedStorage.shared.data.config)
local Response = require(ReplicatedStorage.shared.lib.Response)
local toastsSlice = require(ReplicatedStorage.client.ui.fragments.toasts.toastsSlice)
local ToolboxError = require(ReplicatedStorage.shared.enum.error.ToolboxError)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createShape = remotes.Client:Get("createShape")

local actionCreator = Rodux.makeActionCreator("toolbox/shape/setOptions", function(p)
	return p
end)

local actionCreator2 = Rodux.makeActionCreator("toolbox/shape/createShape", function(id, position)
	return { id = id, position = position }
end)

local actionCreator3 = Rodux.makeActionCreator("toolbox/shape/moveShape", function(id, position)
	return { id = id, position = position }
end)

local actionCreator4 = Rodux.makeActionCreator("toolbox/shape/deleteShape", function(id)
	return { id = id }
end)

local actionCreator5 = Rodux.makeActionCreator("toolbox/shape/clearShapes", function()
	return {}
end)

return {
	reducer = Rodux.combineReducers({
		shapes = Rodux.createReducer({}, {
			[actionCreator2.name] = function(p, p2)
				return Sift.Dictionary.set(p, p2.id, {
					startPoint = p2.position,
					endPoint = p2.position
				})
			end,
			[actionCreator3.name] = function(p, p2)
				return Sift.Dictionary.update(p, p2.id, function(p3)
					return Sift.Dictionary.set(p3, "endPoint", p2.position)
				end)
			end,
			[actionCreator4.name] = function(p, p2)
				return Sift.Dictionary.removeKey(p, p2.id)
			end,
			[actionCreator5.name] = function()
				return {}
			end
		}),
		options = Rodux.createReducer(
			{ geometryType = GeometryType.Circle, polygonVertices = 5, polygonInnerRadius = 0.4 },
			{
				[actionCreator.name] = function(p, data)
					return Sift.Dictionary.join(p, {
						geometryType = data.geometryType,
						polygonVertices = data.polygonVertices,
						polygonInnerRadius = data.polygonInnerRadius
					})
				end
			}
		)
	}),
	actions = {
		setOptions = actionCreator,
		createShape = actionCreator2,
		moveShape = actionCreator3,
		deleteShape = actionCreator4,
		clearShapes = actionCreator5
	},
	thunks = {
		finishShapeAsync = function(p)
			return function(object)
				local state = object:getState()
				local tool = state.toolbox.tools[ToolType.Shape]

				local selectedLayer = state.layers.selectedLayer
				local options = optionsSlice.selectors.selectOptions(state)

				local shape = tool.shapes[p]
				local options2 = tool.options

				local magnitude = (shape.endPoint - shape.startPoint).Magnitude

				if config.tools.shape.minRadius <= magnitude and magnitude <= config.tools.shape.maxRadius then
					createShape:CallServerAsync(selectedLayer, options, {
						options = Sift.Dictionary.set(options2, "geometryType", options2.geometryType.name),
						startPoint = shape.startPoint,
						endPoint = shape.endPoint,
						rotation = getCameraRotation(state)
					}):andThen(Response.promisify):catch(function(text)
						local showToast = toastsSlice.thunks.showToast

						if ToolboxError[text] then
							text = Localization.String.new(("toolbox.toast.error.%s"):format(ToolboxError[text].value))
						end

						object:dispatch(showToast({ text = text, icon = "alert" }))
					end):finally(function()
						object:dispatch(actionCreator4(p))
						object:flush()
					end)
					return
				end

				object:dispatch(actionCreator4(p))
				object:flush()
			end
		end
	}
}