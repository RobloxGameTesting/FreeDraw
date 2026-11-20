local t = require(script.t)

local v = {
	cast = true,
	fromRawValue = true,
	getEnumeratorItems = true,
	getSortedEnumeratorItems = true,
	isEnumValue = true
}

local tuple = t.tuple(t.string, t.union(t.array(t.string), t.keys(t.string)))

local function lockTable(p, p2) -- 3 equivalent calls inferred from this helper
	local v2 = p2 or tostring(p)

	local function protectedFunction(_, p3)
		error(string.format("%q (%s) is not a valid member of %s", tostring(p3), typeof(p3), (tostring(v2))))
	end

	return (setmetatable(p, { __index = protectedFunction, __newindex = protectedFunction }))
end

local function sortByValue(p, p2): boolean
	return p.value < p2.value
end

local function enumerator(p: string, list)
	assert(tuple(p, list))

	local v2 = newproxy(true)
	local v3 = {}
	local v4 = {}
	local count = 0

	function v3.fromRawValue(p2)
		return v4[p2]
	end

	function v3.isEnumValue(p2): boolean
		if typeof(p2) ~= "userdata" then
			return false
		end

		for _, v5 in pairs(v3) do
			if v5 == p2 then
				return true
			end
		end

		return false
	end

	function v3.cast(p2)
		if v3.isEnumValue(p2) then
			return p2
		end

		local v5 = v4[p2]

		if v5 == nil then
			return
				false,
				string.format("Couldn't cast value %q (%s) to enumerator %q", tostring(p2), typeof(p2), (tostring(v2)))
		end

		return v5
	end

	function v3.getEnumeratorItems()
		local enumeratorItems = table.create(count)
		local count2 = 0

		for _, v5 in pairs(v4) do
			count2 += 1
			enumeratorItems[count2] = v5
		end

		return enumeratorItems
	end

	function v3.getSortedEnumeratorItems()
		local sortedEnumeratorItems = table.create(count)
		local count2 = 0

		for _, v5 in pairs(v4) do
			count2 += 1
			sortedEnumeratorItems[count2] = v5
		end

		table.sort(sortedEnumeratorItems, sortByValue)
		return sortedEnumeratorItems
	end

	if next(list) == 1 then
		for _, item in ipairs(list) do
			assert(not v[item], string.format("Cannot use '%s' as a value", (tostring(item))))
			assert(v3[item] == nil, string.format("Already used %q as a value name in enum %q.", item, p))
			assert(v4[item] == nil, string.format("Already used %q as a value in enum %q.", item, p))

			local v5 = newproxy(true)
			local metatable = getmetatable(v5)
			local v6 = string.format("%s.%s", p, item)

			function metatable.__tostring(_)
				return v6
			end

			metatable.__index = lockTable({ -- inferred equivalent call
				name = item,
				type = v2,
				value = item,
				rawName = function()
					return item
				end,
				rawType = function()
					return v2
				end,
				rawValue = function()
					return item
				end
			})

			v3[item] = v5
			v4[item] = v5
			count += 1
		end
	else
		for k, item in pairs(list) do
			assert(not v[k], string.format("Cannot use '%s' as a value", (tostring(k))))
			assert(v3[k] == nil, string.format("Already used %q as a value name in enum %q.", k, p))
			assert(v4[k] == nil, string.format("Already used %q as a value in enum %q.", k, p))

			local v5 = newproxy(true)
			local metatable = getmetatable(v5)
			local v6 = string.format("%s.%s", p, k)

			function metatable.__tostring(_)
				return v6
			end

			metatable.__index = lockTable({ -- inferred equivalent call
				name = k,
				type = v2,
				value = item,
				rawName = function()
					return k
				end,
				rawType = function()
					return v2
				end,
				rawValue = function()
					return item
				end
			})

			v3[k] = v5
			v4[item] = v5
			count += 1
		end
	end

	local metatable = getmetatable(v2)
	metatable.__index = lockTable(v3, p) -- inferred equivalent call

	function metatable.__tostring(_)
		return p
	end

	return v2
end

return (setmetatable({ Enumerator = enumerator }, {
	__call = function(_, p: string, p2)
		return enumerator(p, p2)
	end
}))