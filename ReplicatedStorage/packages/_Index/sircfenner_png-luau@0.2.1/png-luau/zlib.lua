--!native
local function createHuffmanTable(items)
	local v = table.create(15, 0)
	v[0] = 0

	for _, item in items do
		if item > 0 then
			v[item] = (v[item] or 0) + 1
		end
	end

	local v2 = table.create(15)
	local v3 = 1

	for i = 1, 15 do
		v3 = bit32.lshift(v3 + v[i - 1], 1)
		v2[i] = v3
	end

	local result = {}
	local result2 = {}
	local result3 = {}

	for k, item in items do
		if not (item > 0) then
			continue
		end

		result[v2[item]] = k - 1
		result2[k - 1] = bit32.extract(v2[item], 0, item)
		result3[k - 1] = item
		v2[item] += 1
	end

	return result, result2, result3
end

local v = {
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	13,
	15,
	17,
	19,
	23,
	27,
	31,
	35,
	43,
	51,
	59,
	67,
	83,
	99,
	115,
	131,
	163,
	195,
	227,
	258
}

local v2 = {}
local v3 = {}
local v4 = {
	1,
	1,
	1,
	1,
	2,
	2,
	2,
	2,
	3,
	3,
	3,
	3,
	4,
	4,
	4,
	4,
	5,
	5,
	5,
	5,
	0
}

local v5 = {}
local v6 = {
	1,
	2,
	3,
	4,
	5,
	7,
	9,
	13,
	17,
	25,
	33,
	49,
	65,
	97,
	129,
	193,
	257,
	385,
	513,
	769,
	1025,
	1537,
	2049,
	3073,
	4097,
	6145,
	8193,
	12289,
	16385,
	24577
}

local v7 = {
	16,
	17,
	18,
	0,
	8,
	7,
	9,
	6,
	10,
	5,
	11,
	4,
	12,
	3,
	13,
	2,
	14,
	1,
	15
}
local v8 = {
	0,
	0,
	0,
	1,
	1,
	2,
	2,
	3,
	3,
	4,
	4,
	5,
	5,
	6,
	6,
	7,
	7,
	8,
	8,
	9,
	9,
	10,
	10,
	11,
	11,
	12,
	12,
	13,
	13
}

for i = 3, 258 do
	local v9 = nil

	for j = #v, 1, -1 do
		if v[j] <= i then
			v9 = j
			break
		end
	end

	v2[i] = 256 + v9
	v3[i] = i - v[v9]
	v5[i] = v4[v9 - 8] or 0
end

local v9 = {}

for i = 1, 1024 do
	local v10 = nil

	for j = #v6, 1, -1 do
		if v6[j] <= i then
			v10 = j
			break
		end
	end

	v9[i] = v10
end

local huffmanTable, v10, v11 = createHuffmanTable({
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	9,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8
})
local huffmanTable2, v12, v13 = createHuffmanTable(table.create(32, 5))

local function getStoreSize(p: number) -- 2 equivalent calls inferred from this helper
	return math.ceil(p / 32768) * 5 + p
end

local function getDistIdx(p: number)
	if p < 1025 then
		return v9[p]
	end

	if p < 1537 then
		return 21
	end

	if p < 2049 then
		return 22
	end

	if p < 3073 then
		return 23
	end

	if p < 4097 then
		return 24
	end

	if p < 6145 then
		return 25
	end

	if p < 8193 then
		return 26
	end

	if p < 12289 then
		return 27
	end

	if p < 16385 then
		return 28
	end

	return if p < 24577 then 29 else 30
end

local function adler32(buf: buffer, p: number, p2: number)
	local v14 = 1
	local v15 = 0
	local count = 0

	for i = p, p + p2 - 1 do
		v14 += buffer.readu8(buf, i)
		v15 += v14
		count += 1

		if count ~= 8400000 then
			continue
		end

		v14 %= 65521
		v15 %= 65521
		count = 0
	end

	return (bit32.bor(bit32.lshift(v15 % 65521, 16), v14 % 65521))
end

local Zlib = {}

function Zlib.inflate(buf: buffer, buf2: buffer)
	local v14 = buffer.readu8(buf, 0)
	local v15 = buffer.readu8(buf, 1)
	assert(bit32.extract(v14, 0, 4) == 8, "invalid zlib comp method")
	assert(bit32.extract(v14, 4, 4) <= 7, "invalid zlib window size")
	assert(bit32.extract(v15, 5, 1) == 0, "preset dictionary is not allowed")
	assert(bit32.bor(bit32.lshift(v14, 8), v15) % 31 == 0, "zlib header sum mismatch")

	local total = 2
	local v16 = 0

	local function readBit() -- 5 equivalent calls inferred from this helper
		local bit = bit32.extract(buffer.readu8(buf, total), v16)
		v16 += 1

		if v16 == 8 then
			v16 = 0
			total += 1
		end

		return bit
	end

	local function readBits(bitCount: number) -- 13 equivalent calls inferred from this helper
		local bits = buffer.readbits(buf, total * 8 + v16, bitCount)
		v16 += bitCount
		total += bit32.rshift(v16, 3)
		v16 = bit32.band(v16, 7)
		return bits
	end

	local function readHuffmanTable(p) -- 4 equivalent calls inferred from this helper
		local v17 = 2 + readBit() -- inferred equivalent call

		while not p[v17] do
			v17 = 2 * v17 + readBit() -- inferred equivalent call
		end

		return p[v17]
	end

	local total2 = 0

	repeat
		local bit = readBit() -- inferred equivalent call
		local bits = readBits(2) -- inferred equivalent call
		assert(bits ~= 3, "reserved btype")

		if bits == 0 then
			if v16 > 0 then
				total += 1
				v16 = 0
			end

			local v17 = buffer.readu16(buf, total)
			assert(bit32.bxor(v17, (buffer.readu16(buf, total + 2))) == 65535, "len ~= nlen")
			total += 4
			buffer.copy(buf2, total2, buf, total, v17)
			total2 += v17
			total += v17
		else
			local v17 = huffmanTable
			local v18 = huffmanTable2

			if bits == 2 then
				local v19 = readBits(5) + 257 -- inferred equivalent call
				local v20 = readBits(5) + 1 -- inferred equivalent call
				local v21 = readBits(4) + 4 -- inferred equivalent call

				local v22 = table.create(19, 0)

				for i = 1, v21 do
					local v23 = v7[i] + 1
					v22[v23] = readBits(3) -- inferred equivalent call
				end

				local huffmanTable3 = createHuffmanTable(v22)

				local v23 = table.create(v19)
				local v24 = nil

				repeat
					local huffmanTable4 = readHuffmanTable(huffmanTable3) -- inferred equivalent call
					local v25 = 1

					if huffmanTable4 <= 15 then
						v24 = huffmanTable4
					elseif huffmanTable4 == 16 then
						v25 = readBits(2) + 3 -- inferred equivalent call
					elseif huffmanTable4 == 17 then
						v24 = 0
						v25 = readBits(3) + 3 -- inferred equivalent call
					elseif huffmanTable4 == 18 then
						v24 = 0
						v25 = readBits(7) + 11 -- inferred equivalent call
					end

					for _ = 1, v25 do
						table.insert(v23, v24)
					end
				until v19 <= #v23

				v17 = createHuffmanTable(v23)

				local v25 = table.create(v20)
				local v26 = nil

				repeat
					local huffmanTable4 = readHuffmanTable(huffmanTable3) -- inferred equivalent call
					local v27 = 1

					if huffmanTable4 <= 15 then
						v26 = huffmanTable4
					elseif huffmanTable4 == 16 then
						v27 = readBits(2) + 3 -- inferred equivalent call
					elseif huffmanTable4 == 17 then
						v26 = 0
						v27 = readBits(3) + 3 -- inferred equivalent call
					elseif huffmanTable4 == 18 then
						v26 = 0
						v27 = readBits(7) + 11 -- inferred equivalent call
					end

					for _ = 1, v27 do
						table.insert(v25, v26)
					end
				until v20 <= #v25

				v18 = createHuffmanTable(v25)
			end

			repeat
				local huffmanTable3 = readHuffmanTable(v17) -- inferred equivalent call

				if huffmanTable3 < 256 then
					buffer.writeu8(buf2, total2, huffmanTable3)
					total2 += 1
				elseif huffmanTable3 > 256 then
					local v19 = v[huffmanTable3 - 256]

					if huffmanTable3 > 268 then
						v19 += readBits(v4[huffmanTable3 - 264]) -- inferred equivalent call
					elseif huffmanTable3 > 264 then
						v19 += readBit() -- inferred equivalent call
					end

					local huffmanTable4 = readHuffmanTable(v18) -- inferred equivalent call
					local v20 = v6[huffmanTable4 + 1]

					if huffmanTable4 > 5 then
						v20 += readBits(v8[huffmanTable4]) -- inferred equivalent call
					elseif huffmanTable4 > 3 then
						v20 += readBit() -- inferred equivalent call
					end

					if v19 <= v20 then
						buffer.copy(buf2, total2, buf2, total2 - v20, v19)
						total2 += v19
					else
						repeat
							local v21 = math.min(v19, v20)
							buffer.copy(buf2, total2, buf2, total2 - v20, v21)
							total2 += v21
							v19 -= v21
							v20 += v21
						until v19 == 0
					end
				end
			until huffmanTable3 == 256
		end
	until bit == 1

	if v16 > 0 then
		v16 = 0
		total += 1
	end

	assert(
		adler32(buf2, 0, buffer.len(buf2)) == bit32.byteswap((buffer.readu32(buf, total))),
		"adler-32 checksum mismatch"
	)

	return total2
end

function Zlib.deflate(buf: buffer)
	local v14 = buffer.len(buf)
	local buf2 = buffer.create(getStoreSize(v14) + 6) -- inferred equivalent call

	buffer.writeu16(buf2, 0, 24184)

	local total = 2
	local v15 = 0

	local function writeBits(value: number, bitCount: number) -- 5 equivalent calls inferred from this helper
		buffer.writebits(buf2, total * 8 + v15, bitCount, value)
		v15 += bitCount
		total += bit32.rshift(v15, 3)
		v15 = bit32.band(v15, 7)
	end

	local function writeHuffmanBits(p: number, bitCount: number)
		local v16 = bit32.bor(bit32.band(bit32.rshift(p, 1), 1431655765), (bit32.band(bit32.lshift(p, 1), 2863311530)))
		local v17 = bit32.bor(
			bit32.band(bit32.rshift(v16, 2), 858993459),
			(bit32.band(bit32.lshift(v16, 2), 3435973836))
		)
		local v18 = bit32.bor(
			bit32.band(bit32.rshift(v17, 4), 252645135),
			(bit32.band(bit32.lshift(v17, 4), 4042322160))
		)
		local v19 = bit32.bor(
			bit32.band(bit32.rshift(v18, 8), 16711935),
			(bit32.band(bit32.lshift(v18, 8), 4278255360))
		)
		writeBits( -- inferred equivalent call
			bit32.band(
				bit32.rshift(bit32.bor(bit32.rshift(v19, 16), (bit32.lshift(v19, 16))), 32 - bitCount),
				bit32.lshift(1, bitCount) - 1
			),
			bitCount
		)
	end

	local function writeLitOrLen(p: number) -- 2 equivalent calls inferred from this helper
		writeHuffmanBits(v10[p], v11[p])
	end

	local function writeBackRef(y: number, z: number)
		writeLitOrLen(v2[z]) -- inferred equivalent call

		if z > 10 then
			writeBits(v3[z], v5[z]) -- inferred equivalent call
		end

		local distIdx = getDistIdx(y)
		writeHuffmanBits(v12[distIdx - 1], v13[distIdx - 1])

		if distIdx > 3 then
			writeBits(y - v6[distIdx], v8[distIdx - 1]) -- inferred equivalent call
		end
	end

	local function getLitOrLenSize(p: number) -- 4 equivalent calls inferred from this helper
		return v11[p]
	end

	local function getBackRefSize(p: number, p2: number) -- 1 equivalent call inferred from this helper
		local distIdx = getDistIdx(p)
		return getLitOrLenSize(v2[p2]) + v5[p2] + v13[distIdx - 1] + (v8[distIdx - 1] or 0) -- inferred equivalent call
	end

	local v16 = {}
	local v17 = {}
	local v18 = {}
	local count = 0

	local function insertNode(p: number, p2: number) -- 2 equivalent calls inferred from this helper
		count += 1
		v16[count] = p
		v17[count] = p2
		return count
	end

	local function clearTables() -- 1 equivalent call inferred from this helper
		table.clear(v16)
		table.clear(v17)
		table.clear(v18)
		count = 0
	end

	for i = 0, v14 - 1, 32768 do
		local v19 = math.min(v14, i + 32768)
		local v20 = i
		local total2 = 0
		local v21 = {}

		while v20 < v19 - 3 do
			local v22 = bit32.band(buffer.readu32(buf, v20), 16777215)
			local count3 = insertNode(v20, v18[v22] or 0) -- inferred equivalent call
			v18[v22] = count3

			local v23 = v17[count3]
			local count2 = 0
			local v24 = 0
			local v25 = -1

			while v23 do
				local v26 = v16[v23] or -1e999

				if not (v20 - 32510 <= v26 and count2 < 12 and v24 < 96) then
					break
				end

				local v27 = 3
				local v28 = v16[v23]

				local v29 = math.min(v19, v20 + 258)
				local v30

				if v20 + v24 < v29 and buffer.readu8(buf, v28 + v24) ~= buffer.readu8(buf, v20 + v24) then
					v30 = true
				else
					v30 = false
				end

				while
					not v30
					and v27 < 258
					and v20 + v27 < v19
					and buffer.readu8(buf, v28 + v27) == buffer.readu8(buf, v20 + v27)
				do
					v27 += 1
				end

				if v24 < v27 then
					if v27 >= 258 then
						v25 = v28
						v24 = v27
						break
					end

					v25 = v28
					v24 = v27
				end

				v23 = v17[v23]
				count2 += 1
			end

			if v24 == 0 then
				local v26 = buffer.readu8(buf, v20)
				total2 += getLitOrLenSize(v26) -- inferred equivalent call

				table.insert(v21, (vector.create(0, v26)))
				v20 += 1
			else
				total2 += getBackRefSize(v20 - v25, v24) -- inferred equivalent call
				table.insert(v21, (vector.create(1, v20 - v25, v24)))

				for j = v20 + 1, math.min(v20 + v24 - 1, v19 - 4) do
					local v26 = bit32.band(buffer.readu32(buf, j), 16777215)
					v18[v26] = insertNode(j, v18[v26] or 0) -- inferred equivalent call
				end

				v20 += v24
			end
		end

		while v20 < v19 do
			local v22 = buffer.readu8(buf, v20)
			total2 += getLitOrLenSize(v22) -- inferred equivalent call

			table.insert(v21, (vector.create(0, v22)))
			v20 += 1
		end

		local v22 = total2 + getLitOrLenSize(256) -- inferred equivalent call

		table.insert(v21, Vector3.new(0, 256, 0))

		if v19 == v14 then
			buffer.writebits(buf2, total * 8 + v15, 1, 1)
		else
			buffer.writebits(buf2, total * 8 + v15, 1, 0)
		end

		v15 += 1
		total += bit32.rshift(v15, 3)
		v15 = bit32.band(v15, 7)

		local v23 = v19 - i

		if math.ceil(v22 / 8) + 1 < getStoreSize(v23) then -- inferred equivalent call
			writeBits(1, 2) -- inferred equivalent call

			for _, v24 in v21 do
				if v24.x == 0 then
					writeLitOrLen(v24.y) -- inferred equivalent call
				else
					writeBackRef(v24.y, v24.z)
				end
			end
		else
			writeBits(0, 2) -- inferred equivalent call

			if v15 > 0 then
				total += 1
				v15 = 0
			end

			buffer.writeu16(buf2, total, v23)
			buffer.writeu16(buf2, total + 2, (bit32.bxor(65535, v23)))
			buffer.copy(buf2, total + 4, buf, i, v23)
			total += v23 + 4
		end

		if count > 50000 then
			clearTables() -- inferred equivalent call
		end
	end

	if v15 > 0 then
		total += 1
	end

	local v19 = bit32.byteswap(adler32(buf, 0, buffer.len(buf)))
	buffer.writeu32(buf2, total, v19)

	return buf2, total + 4
end

return Zlib