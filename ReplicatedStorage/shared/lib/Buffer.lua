local Buffer = {}

function Buffer.createReadBuffer(value)
	local v = 1

	local function process(...)
		v = select(-1, ...)
		return ...
	end

	return {
		read = function(p)
			return process(string.unpack(p, value, v))
		end,
		readRaw = function(p)
			local v2 = v
			v += p
			local v3 = v - 1
			return string.byte(value, v2, v3)
		end
	}
end

function Buffer.createWriteBuffer()
	local v = {}

	return {
		write = function(...)
			table.insert(v, string.pack(...))
		end,
		writeRaw = function(p)
			table.insert(v, p)
		end,
		finish = function()
			return table.concat(v, "")
		end
	}
end

return Buffer