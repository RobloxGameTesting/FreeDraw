local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local remotes = require(ReplicatedStorage.shared.remotes)

local createLayer = remotes.Client:Get("createLayer")
local renameLayer = remotes.Client:Get("renameLayer")
local moveLayer = remotes.Client:Get("moveLayer")
local setLayerVisible = remotes.Client:Get("setLayerVisible")
local mergeLayer = remotes.Client:Get("mergeLayer")
local deleteLayer = remotes.Client:Get("deleteLayer")

local actionCreator = Rodux.makeActionCreator("layers/moveLayer", function(id, p)
	return { id = id, index = p }
end)

local actionCreator2 = Rodux.makeActionCreator("layers/renameLayer", function(id, name)
	return { id = id, name = name }
end)

local actionCreator3 = Rodux.makeActionCreator("layers/setLayerVisible", function(id, visible)
	return { id = id, visible = visible }
end)

local actionCreator4 = Rodux.makeActionCreator("layers/mergeLayer", function(id, targetId)
	return { id = id, targetId = targetId }
end)

local actionCreator5 = Rodux.makeActionCreator("layers/deleteLayer", function(id)
	return { id = id }
end)

local actionCreator6 = Rodux.makeActionCreator("layers/selectLayer", function(id)
	return { id = id }
end)

local actionCreator7 = Rodux.makeActionCreator("layers/syncLayers", function(layers)
	return { layers = layers }
end)

return {
	reducer = Rodux.createReducer({ selectedLayer = nil, layers = {} }, {
		[actionCreator2.name] = function(p, p2)
			return Sift.Dictionary.update(p, "layers", function(p3)
				return Sift.List.map(p3, function(p4)
					if p4.id == p2.id then
						return Sift.Dictionary.set(p4, "name", p2.name)
					end

					return p4
				end)
			end)
		end,
		[actionCreator.name] = function(p, p2)
			local where = Sift.List.findWhere(p.layers, function(p3): boolean
				return p3.id == p2.id
			end)

			local index = p2.index

			local layer = p.layers[where]

			return Sift.Dictionary.update(p, "layers", function(p3)
				local filtered = Sift.List.filter(p3, function(p4): boolean
					return p4.id ~= layer.id
				end)

				local v = Sift.List.insert(filtered, index, layer)
				return (Sift.List.map(v, function(p4, p5)
					return Sift.Dictionary.set(p4, "index", p5)
				end))
			end)
		end,
		[actionCreator3.name] = function(p, p2)
			return Sift.Dictionary.update(p, "layers", function(p3)
				return Sift.List.map(p3, function(p4)
					if p4.id == p2.id then
						return Sift.Dictionary.set(p4, "visible", p2.visible)
					end

					return p4
				end)
			end)
		end,
		[actionCreator4.name] = function(p, p2)
			local where = Sift.List.findWhere(p.layers, function(p3): boolean
				return p3.id == p2.id
			end)

			return {
				selectedLayer = p2.targetId,
				layers = Sift.List.removeIndex(p.layers, where)
			}
		end,
		[actionCreator5.name] = function(p, p2)
			local where = Sift.List.findWhere(p.layers, function(p3): boolean
				return p3.id == p2.id
			end)
			local selectedLayer

			if p2.id == p.selectedLayer then
				if p.layers[1] then
					selectedLayer = p.layers[1].id
				end
			else
				selectedLayer = p.selectedLayer
			end

			return {
				selectedLayer = selectedLayer,
				layers = Sift.List.removeIndex(p.layers, where)
			}
		end,
		[actionCreator6.name] = function(p, p2)
			return Sift.Dictionary.set(p, "selectedLayer", p2.id)
		end,
		[actionCreator7.name] = function(p, p2)
			local v = Sift.List.findWhere(Sift.Dictionary.values(p2.layers), function(p3): boolean
				return p3.id == p.selectedLayer
			end) or 1
			local selectedLayer

			if v and p2.layers[v] then
				selectedLayer = p2.layers[v].id
			end

			return { selectedLayer = selectedLayer, layers = p2.layers }
		end
	}),
	actions = {
		moveLayer = actionCreator,
		renameLayer = actionCreator2,
		setLayerVisible = actionCreator3,
		mergeLayer = actionCreator4,
		deleteLayer = actionCreator5,
		selectLayer = actionCreator6,
		syncLayers = actionCreator7
	},
	thunks = {
		createLayerAsync = function(p)
			return function()
				createLayer:CallServerAsync(p)
			end
		end,
		moveLayerAsync = function(p, p2)
			return function(object)
				moveLayer:CallServerAsync(p, p2)
				object:dispatch(actionCreator(p, p2))
			end
		end,
		renameLayerAsync = function(p, p2)
			return function(object)
				renameLayer:CallServerAsync(p, p2)
				object:dispatch(actionCreator2(p, p2))
			end
		end,
		setLayerVisibleAsync = function(p, p2)
			return function(object)
				setLayerVisible:CallServerAsync(p, p2)
				object:dispatch(actionCreator3(p, p2))
			end
		end,
		mergeLayerAsync = function(p)
			return function(object)
				local layers = object:getState().layers.layers

				local id = layers[Sift.List.findWhere(layers, function(p2): boolean
					return p2.id == p
				end) - 1].id

				mergeLayer:CallServerAsync(p, id)
				object:dispatch(actionCreator4(p, id))
			end
		end,
		deleteLayerAsync = function(p)
			return function(object)
				deleteLayer:CallServerAsync(p)
				object:dispatch(actionCreator5(p))
			end
		end
	}
}