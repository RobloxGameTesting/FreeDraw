local Promise = require(script.Parent.Parent.Promise)
local AccessLayer = require(script.Parent.Layers.AccessLayer)
local DocumentData = require(script.Parent.DocumentData)
local stackSkipAssert = require(script.Parent.stackSkipAssert)
local stackSkipAssert2 = stackSkipAssert.stackSkipAssert

local Document = {}
Document.__index = Document

function Document.new(collection, name)
	return (setmetatable({ collection = collection, name = name, _data = nil }, Document))
end

function Document:readyPromise()
	if self._readyPromise == nil then
		self._readyPromise = Promise.new(function(callback)
			self._data = DocumentData.new({
				lockSession = AccessLayer.acquireLockSession(
					self.collection.name,
					self.name,
					self.collection._migrations
				),
				collection = self.collection,
				name = self.name
			})

			callback(self)
		end)
	end

	return Promise.resolve(self._readyPromise)
end

function Document:get(p)
	local v = tostring(p)

	stackSkipAssert2(
		self.collection:keyExists(v),
		("Key %q does not appear in %q's schema."):format(v, self.collection.name)
	)

	return self._data:read()[v]
end

function Document:set(p, p2)
	stackSkipAssert2(self._data:isClosed() == false, "Attempt to call :set() on a closed Document")

	local v = tostring(p)

	stackSkipAssert2(self.collection:validateKey(v, p2))

	local v2 = self._data:read()
	v2[v] = p2
	self._data:write(v2)
end

function Document:save()
	stackSkipAssert2(self._data:isClosed() == false, "Attempt to call :save() on a closed Document")

	return Promise.new(function(callback)
		self._data:save()
		callback()
	end)
end

function Document:close()
	stackSkipAssert2(self._data:isClosed() == false, "Attempt to call :close() on a closed Document")

	return Promise.new(function(callback)
		self._data:close()
		callback()
	end):finally(function()
		self.collection:_removeDocument(self.name)
	end)
end

function Document:isClosed()
	return self._data:isClosed()
end

return Document