local MigrationLayer = require(script.Parent.Parent.MigrationLayer)
local Error = require(script.Parent.Parent.Parent.Error)
local Promise = require(script.Parent.Parent.Parent.Parent.Promise)
local getTime = require(script.Parent.Parent.Parent.getTime)
local getTime2 = getTime.getTime

local HttpService = game:GetService("HttpService")

local function consistencyError() -- 1 equivalent call inferred from this helper
	return Error.new({
		kind = Error.Kind.LockConsistencyViolation,
		error = "Lock was changed after we acquired it. Aborting operation."
	})
end

local LockSession = {}
LockSession.__index = LockSession

function LockSession.new(collection, p, migrations)
	assert(migrations ~= nil, "migrations is nil")

	return (setmetatable({
		collection = collection,
		key = p,
		_lockId = HttpService:GenerateGUID(),
		_locked = false,
		_value = nil,
		_lastWrite = -1,
		_pendingData = nil,
		_pendingPromise = nil,
		_pendingClose = false,
		_migrations = migrations
	}, LockSession))
end

function LockSession:lock()
	if self._locked then
		error("Attempt to lock when already locked")
	end

	local v = nil

	self._value = MigrationLayer.update(self.collection, self.key, function(p)
		local v2 = p or { createdAt = os.time(), updatedAt = os.time() }

		if type(v2.lockedAt) == "number" and os.time() - v2.lockedAt < 300 then
			v = false
			return nil
		end

		v2.lockId = self._lockId
		v2.lockedAt = os.time()

		v = true

		return v2
	end, self._migrations)

	if not v or self._value.lockId ~= self._lockId then
		error(Error.new({ kind = Error.Kind.CouldNotAcquireLock, error = "Could not acquire lock" }))

		return
	end

	self._locked = true
	self._lastWrite = getTime2()
	return self
end

function LockSession:_checkConsistency(p)
	return p.lockId and p.lockId == self._lockId
end

function LockSession:_ensureLocked()
	if not self._locked then
		error("Attempt to access LockSession without a lock")
	end
end

function LockSession:write(pendingData2)
	self:_ensureLocked()

	if self._pendingClose then
		error("Attempt to write to a LockSession that is pending to be closed.")
	end

	if pendingData2 == nil then
		warn("[Debug, remove for release] LockSession:write data is nil!")
	end

	if getTime2() - self._lastWrite < 7 then
		warn("Queueing key =", self.collection, self.key)
		self._pendingData = pendingData2

		if not self._pendingPromise then
			self._pendingPromise = Promise.delay(7 - (getTime2() - self._lastWrite)):andThen(function()
				self._pendingPromise = nil

				if self._pendingClose then
					self._pendingClose = false
					self:unlock()
				else
					local pendingData = self._pendingData
					self._pendingData = nil
					self:write(pendingData)
				end
			end)
		end

		return self._pendingPromise:expect()
	else
		local v = nil
		self._value = MigrationLayer.update(self.collection, self.key, function(p)
			if not self:_checkConsistency(p) then
				v = consistencyError() -- inferred equivalent call
				return nil
			end

			p.updatedAt = os.time()
			p.lockedAt = os.time()
			p.data = pendingData2

			return p
		end, self._migrations)

		if v then
			error(v)
		end

		self._lastWrite = getTime2()
	end
end

function LockSession:read()
	self:_ensureLocked()

	return self._value.data
end

function LockSession:getUpdatedTimestamp()
	self:_ensureLocked()
	return self._value.updatedAt
end

function LockSession:getCreatedTimestamp()
	self:_ensureLocked()
	return self._value.createdAt
end

function LockSession:unlockWithFinalData(pendingData)
	self._pendingData = pendingData

	return self:unlock()
end

function LockSession:unlock()
	if getTime2() - self._lastWrite < 7 or self._pendingPromise then
		self._pendingClose = true

		if self._pendingPromise == nil then
			self._pendingPromise = Promise.delay(7 - (getTime2() - self._lastWrite)):andThen(function()
				self._pendingPromise = nil
				self:unlock()
			end)
		end

		return self._pendingPromise:expect()
	end

	self._locked = false
	self._value = nil

	MigrationLayer.update(self.collection, self.key, function(p)
		if not self:_checkConsistency(p) then
			return nil
		end

		if self._pendingData then
			p.data = self._pendingData
			self._pendingData = nil
		end

		p.lockedAt = nil
		p.lockId = nil

		return p
	end, self._migrations)
end

return LockSession