require("../Types")

local v = {
	[0] = { 1, 2, 4, 8, 16 },
	[2] = { 8, 16 },
	[3] = { 1, 2, 4, 8 },
	[4] = { 8, 16 },
	[6] = { 8, 16 }
}

local function read(buf: buffer, p)
	assert(p.length == 13, "IHDR data must be 13 bytes")

	local offset = p.offset

	local width = bit32.byteswap((buffer.readu32(buf, offset)))
	local height = bit32.byteswap((buffer.readu32(buf, offset + 4)))
	local bitDepth = buffer.readu8(buf, offset + 8)
	local colorType = buffer.readu8(buf, offset + 9)
	local v2 = buffer.readu8(buf, offset + 10)
	local v3 = buffer.readu8(buf, offset + 11)
	local v4 = buffer.readu8(buf, offset + 12)

	local v5 = width > 0 and width <= 2147483648 and height > 0 and height <= 2147483648
	assert(v5, "invalid dimensions")
	assert(v2 == 0, "invalid compression method")
	assert(v3 == 0, "invalid filter method")
	assert(v4 == 0 or v4 == 1, "invalid interlace method")

	local v6 = v[colorType]
	assert(v6 ~= nil, "invalid color type")
	assert(table.find(v6, bitDepth) ~= nil, "invalid bit depth")

	return {
		width = width,
		height = height,
		bitDepth = bitDepth,
		colorType = colorType,
		interlaced = v4 == 1
	}
end

return read