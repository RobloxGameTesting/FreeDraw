local DataLayer = require(script.Parent.DataLayer)

local MigrationLayer = {}

function MigrationLayer._unpack(p, list)
	local v = p or {
		generation = #list,
		data = nil
	}

	local data = v.data
	local generation = v.generation

	if generation < #list then
		for i = generation + 1, #list do
			data.data = list[i](data.data)
		end
	end

	return data
end

function MigrationLayer._pack(p, list)
	return {
		data = p,
		generation = #list
	}
end

function MigrationLayer.update(p, p2, callback, p3)
	local v = nil

	DataLayer.update(p, p2, function(p4)
		v = callback(MigrationLayer._unpack(p4, p3))

		if v == nil then
			return nil
		end

		return MigrationLayer._pack(v, p3)
	end)

	return v
end

function MigrationLayer.read(p, p2, p3)
	return MigrationLayer._unpack(DataLayer.read(p, p2), p3)
end

return MigrationLayer