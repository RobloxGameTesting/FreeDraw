local v = {}
local count = 0

for i = 32, 127 do
	if not (i ~= 34 and i ~= 92) then
		continue
	end

	local v2 = string.char(i)
	v[v2] = count
	v[count] = v2
	count += 1
end

local v2 = {}

for i = 1, 34 do
	local v3 = ({ 34, 92, 127 })[i - 31] or i
	local v4 = string.char(v3)
	local v5 = string.char(v3 + 31)
	v2[v4] = v5
	v2[v5] = v4
end

local function escape(value)
	return (value:gsub("[%c\"\\]", function(p)
		return "\127" .. v2[p]
	end))
end

local function unescape(value)
	return (value:gsub("\127(.)", function(p)
		return v2[p]
	end))
end

local function copy(items) -- 2 equivalent calls inferred from this helper
	local result = {}

	for k, item in pairs(items) do
		result[k] = item
	end

	return result
end

local function tobase93(p) -- 3 equivalent calls inferred from this helper
	local v3 = ""

	repeat
		local v4 = p % 93
		v3 = v[v4] .. v3
		p = (p - v4) / 93
	until p == 0

	return v3
end

local function tobase10(value)
	local total = 0

	for i = 1, #value do
		total += 93 ^ (i - 1) * v[value:sub(-i, -i)]
	end

	return total
end

local LZW = {}

function LZW.compress(value)
	local result = copy(v) -- inferred equivalent call
	local v3 = ""
	local v4 = {}
	local count2 = #result
	local v5 = 1
	local v6 = {}
	local count3 = 0
	local function listkey(p)
		local v7 = tobase93(result[p]) -- inferred equivalent call
		local v8 = #v7

		if v5 < v8 then
			local v9 = v5
			local v10 = #v7
			local v11 = count3
			v5 = v10
			count3 = 0
			v6[v9] = v11
		end

		v4[#v4 + 1] = (" "):rep(v5 - #v7) .. v7
		count3 += 1
	end

	local v7 = value:gsub("[%c\"\\]", function(p)
		return "\127" .. v2[p]
	end)

	for i = 1, #v7 do
		local v8 = v7:sub(i, i)
		local v9 = v3 .. v8

		if result[v9] then
			v3 = v9
		else
			local v10 = tobase93(result[v3]) -- inferred equivalent call

			if v5 < #v10 then
				local v11 = #v10
				v6[v5] = count3
				v5 = v11
				count3 = 0
			end

			v4[#v4 + 1] = (" "):rep(v5 - #v10) .. v10
			count3 += 1

			count2 += 1
			result[v9] = count2
			result[count2] = v9
			v3 = v8
		end
	end

	local v8 = tobase93(result[v3]) -- inferred equivalent call

	if v5 < #v8 then
		local v9 = #v8
		v6[v5] = count3
		v5 = v9
		count3 = 0
	end

	v4[#v4 + 1] = (" "):rep(v5 - #v8) .. v8
	count3 += 1

	v6[v5] = count3
	return table.concat(v6, ",") .. "|" .. table.concat(v4)
end

function LZW.decompress(value)
	local result = copy(v) -- inferred equivalent call
	local match, v3 = value:match("(.-)|(.*)")
	local v4 = {}
	local total = 1
	local v5 = {}

	for k in match:gmatch("%d+") do
		local v6 = #v4 + 1
		v4[v6] = v3:sub(total, total + k * v6 - 1)
		total += k * v6
	end

	local v6 = nil

	for i = 1, #v4 do
		for k in v4[i]:gmatch(("."):rep(i)) do
			local v7 = result[tobase10(k)]

			if v6 then
				if v7 then
					v5[#v5 + 1] = v7
					result[#result + 1] = v6 .. v7:sub(1, 1)
				else
					v7 = v6 .. v6:sub(1, 1)
					v5[#v5 + 1] = v7
					result[#result + 1] = v7
				end
			else
				v5[1] = v7
			end

			v6 = v7
		end
	end

	return (table.concat(v5):gsub("\127(.)", function(p)
		return v2[p]
	end))
end

return LZW