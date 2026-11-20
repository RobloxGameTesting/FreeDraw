local LockSession = require(script.LockSession)
local MigrationLayer = require(script.Parent.MigrationLayer)
local AccessLayer = {}

function AccessLayer.acquireLockSession(p, p2, p3)
	return LockSession.new(p, p2, p3):lock()
end

function AccessLayer.readWithoutLock(p, p2, p3)
	return MigrationLayer.read(p, p2, p3)
end

return AccessLayer