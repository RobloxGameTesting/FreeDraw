local LZW = require(script.Parent.Parent.LZW)

return {
	["compressed/1"] = {
		pack = function(p)
			return LZW.compress(p)
		end,
		unpack = function(p)
			return LZW.decompress(p)
		end
	}
}