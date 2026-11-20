require("../Types")

local function readU16(buf: buffer, offset: number, bitDepth: number) -- 4 equivalent calls inferred from this helper
	return (bit32.extract(
		bit32.bor(bit32.lshift(buffer.readu8(buf, offset), 8), (buffer.readu8(buf, offset + 1))),
		0,
		bitDepth
	))
end

local function read(buf: buffer, p, p2, p3)
	local gray = -1
	local red = -1
	local green = -1
	local blue = -1

	if p2.colorType == 0 then
		assert(p.length == 2, "invalid tRNS length for color type")
		gray = readU16(buf, p.offset, p2.bitDepth) -- inferred equivalent call
	elseif p2.colorType == 2 then
		assert(p.length == 6, "invalid tRNS length for color type")
		red = readU16(buf, p.offset, p2.bitDepth) -- inferred equivalent call
		green = readU16(buf, p.offset + 2, p2.bitDepth) -- inferred equivalent call
		blue = readU16(buf, p.offset + 4, p2.bitDepth) -- inferred equivalent call
	else
		local length = p.length
		assert(p3, "tRNS requires PLTE for color type")
		assert(length <= #p3.colors, "tRNS specified too many PLTE alphas")

		for i = 1, length do
			p3.colors[i].a = buffer.readu8(buf, p.offset + i - 1)
		end
	end

	return { gray = gray, red = red, green = green, blue = blue }
end

return read