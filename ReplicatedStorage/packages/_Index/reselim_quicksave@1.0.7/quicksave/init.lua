local t = require(script.Parent.t)
local Promise = require(script.Parent.Promise)
local Collection = require(script.Collection)
local Quicksave = { t = t, Promise = Promise, Error = require(script.Error), _collections = {} }

function Quicksave.createCollection(p, p2)
	if Quicksave._collections[p] then
		error(("Collection %q already exists"):format(p))
	end

	Quicksave._collections[p] = Collection.new(p, p2)

	return Quicksave._collections[p]
end

function Quicksave.getCollection(p)
	return Quicksave._collections[p] or error(("Collection %q hasn't been created yet!"):format(p))
end

return Quicksave