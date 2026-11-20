local RetryLayer = require(script.Parent.RetryLayer)

local HttpService = game:GetService("HttpService")

local raw = require(script.Schemes.raw)
local compressed = require(script.Schemes.compressed)

local DataLayer = {
	schemes = { ["raw/1"] = raw["raw/1"], ["compressed/1"] = compressed["compressed/1"] }
}

function DataLayer._unpack(p)
	if p == nil then
		return nil
	end

	local scheme = p.scheme

	if not DataLayer.schemes[scheme] then
		error(("Unknown scheme: %q"):format(scheme))
	end

	return HttpService:JSONDecode(DataLayer.schemes[scheme].unpack(p.data))
end

function DataLayer._pack(p)
	local jsonEncode = HttpService:JSONEncode(p)

	local scheme = #jsonEncode > 1e999 and "compressed/1" or "raw/1"

	return {
		scheme = scheme,
		data = DataLayer.schemes[scheme].pack(jsonEncode)
	}
end

function DataLayer.update(p, p2, callback)
	local v = nil

	RetryLayer.update(p, p2, function(p3)
		v = callback(DataLayer._unpack(p3))

		if v == nil then
			return nil
		end

		return DataLayer._pack(v)
	end)

	return v
end

function DataLayer.read(p, p2)
	return DataLayer._unpack(RetryLayer.read(p, p2))
end

return DataLayer