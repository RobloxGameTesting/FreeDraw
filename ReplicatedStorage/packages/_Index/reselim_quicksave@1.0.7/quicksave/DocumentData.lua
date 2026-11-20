local Error = require(script.Parent.Error)
local function copyDeep(defaultData)
	local result = {}

	for k, item in pairs(defaultData) do
		if type(item) == "table" then
			result[k] = copyDeep(item)
		else
			result[k] = item
		end
	end

	return result
end

local DocumentData = {}
DocumentData.__index = DocumentData

function DocumentData.new(data)
	return (setmetatable({
		_lockSession = data.lockSession,
		_readOnlyData = data.readOnlyData,
		_collection = data.collection,
		_name = data.name,
		_currentData = nil,
		_dataLoaded = false,
		_closed = false
	}, DocumentData))
end

function DocumentData:isClosed()
	return self._closed
end

function DocumentData:_load()
	if self._lockSession then
		return self._lockSession:read()
	end

	return self._readOnlyData
end

function DocumentData:read()
	if self._dataLoaded ~= false then
		return self._currentData
	end

	local currentData = self:_load()

	if currentData == nil then
		local defaultData = self._collection.defaultData
		currentData = defaultData and copyDeep(defaultData) or {}
	end

	local v, err = self._collection:validateData(currentData)

	if not v then
		error(Error.new({
			kind = Error.Kind.SchemaValidationFailed,
			error = err,
			context = ("Schema validation failed when loading data in collection %q key %q"):format(
				self._collection.name,
				self._name
			)
		}))
	end

	self._currentData = currentData
	self._dataLoaded = true

	return self._currentData
end

function DocumentData:write(currentData)
	if self._lockSession == nil then
		error("Can't write to a readonly DocumentData")
	end

	self._currentData = currentData
end

function DocumentData:save()
	if self._lockSession == nil then
		error("Can't save on a readonly DocumentData")
	end

	self._lockSession:write(self._currentData)
end

function DocumentData:close()
	self._closed = true

	if self._lockSession then
		self._lockSession:unlockWithFinalData(self._currentData)
	end
end

return DocumentData