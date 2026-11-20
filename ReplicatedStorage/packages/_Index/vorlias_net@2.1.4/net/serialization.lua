local Serialization = {}

function Serialization:Serialize()
	if type(self) == "number" or type(self) == "string" or type(self) == "boolean" then
		return self
	end

	if type(self) ~= "table" then
		error("Cannot serialize type: " .. type(self), 2)
	end

	if self.Serialize ~= nil then
		return self:Serialize()
	end

	local result = {}

	for k, item in pairs(self) do
		if type(item) == "table" then
			result[k] = Serialization.Serialize(item)
		else
			result[k] = item
		end
	end

	return result
end

local function isMixed(items)
	assert(type(items) == "table")
	local typeName = nil
	local v = false

	for k, item in next, items do
		if typeName and typeName ~= type(k) then
			return true
		end

		typeName = type(k)

		if type(item) == "table" then
			v = v and isMixed(item) and (getmetatable(item) and true or false)
		end
	end

	return v
end

function Serialization.IsSerializable(p): boolean
	local typeName = type(p)

	if typeName == "number" or typeName == "boolean" or typeName == "string" then
		return true
	end

	if typeName == "table" then
		return not (isMixed(p) or getmetatable(p))
	end

	return typeName == "userdata" and typeof(typeName) ~= "userdata"
end

function Serialization.Deserialize(p, object)
	assert(type(p) == "table")

	if object and type(object) == "table" and object.deserialize then
		return object:deserialize(p)
	end
end

return Serialization