local Promise = require(script.Parent.Parent.Promise)
local t = require(script.Parent.Parent.t)
local Document = require(script.Parent.Document)
local stackSkipAssert = require(script.Parent.stackSkipAssert)
local stackSkipAssert2 = stackSkipAssert.stackSkipAssert
local getTime = require(script.Parent.getTime)
local getTime2 = getTime.getTime

local Collection = {}
Collection.__index = Collection

function Collection.new(name, options)
	local v = options or {}

	stackSkipAssert2(v.schema ~= nil, "You must provide a schema in options")

	local strictInterface = t.strictInterface(v.schema)

	local v2, v3 = strictInterface(v.defaultData)

	if not v2 then
		error(
			("The default data you provided for collection %q does not pass your schema requirements.\n\n%s\n"):format(
				name,
				v3
			),
			2
		)
	end

	return (setmetatable({
		name = name,
		schema = v.schema,
		runSchema = strictInterface,
		defaultData = v.defaultData,
		_migrations = v.migrations or {},
		_activeDocuments = {},
		_justClosedDocuments = {}
	}, Collection))
end

function Collection:getDocument(p)
	local v = tostring(p)

	if self._justClosedDocuments[v] then
		local v2 = 7 - (getTime2() - self._justClosedDocuments[v])

		if v2 > 0 then
			warn(("Document %q in %q was recently closed. Your getDocument call will be delayed by %.1f seconds."):format(
				v,
				self.name,
				v2
			))

			Promise.delay(v2):await()
		end
	end

	if self._activeDocuments[v] == nil then
		self._activeDocuments[v] = Document.new(self, v)
	end

	local document = self._activeDocuments[v]:readyPromise()

	document:catch(function()
		self._activeDocuments[v] = nil
	end)

	return document
end

function Collection:getLatestMigrationVersion()
	return #self._migrations
end

function Collection.validateData(p, p2)
	return p.runSchema(p2)
end

function Collection:keyExists(p): boolean
	return self.schema[p] ~= nil
end

function Collection:validateKey(p, p2)
	if self:keyExists(p) then
		return self.schema[p](p2)
	end

	return false, ("Key %q is not present in %q's schema."):format(p, self.name)
end

function Collection:_removeDocument(p)
	self._justClosedDocuments[p] = getTime2()
	self._activeDocuments[p] = nil

	Promise.delay(7):andThen(function()
		self._justClosedDocuments[p] = nil
	end)
end

return Collection