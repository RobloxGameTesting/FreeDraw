local DataStoreService = game:GetService("DataStoreService")

local DataStoreLayer = { _dataStores = {} }

function DataStoreLayer._getDataStore(p)
	if DataStoreLayer._dataStores[p] == nil then
		DataStoreLayer._dataStores[p] = DataStoreService:GetDataStore(p, "_package/eryn.io/quicksave")
	end

	return DataStoreLayer._dataStores[p]
end

function DataStoreLayer.perform(p, p2, ...)
	local dataStore = DataStoreLayer._getDataStore(p2)

	return dataStore[p](dataStore, ...)
end

return DataStoreLayer