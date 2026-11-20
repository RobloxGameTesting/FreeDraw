local Util = require(script.Parent.Util)

local function unescapeOperators(value)
	for _, v in ipairs({ "%.", "%?", "%*", "%*%*" }) do
		value = value:gsub("\\" .. v, v:gsub("%%", ""))
	end

	return value
end

local Argument = {}
Argument.__index = Argument

function Argument.new(command, data, rawValue)
	local v = {
		Command = command,
		Type = nil,
		Name = data.Name,
		Object = data,
		Required = data.Default == nil and data.Optional ~= true,
		Executor = command.Executor,
		RawValue = rawValue,
		RawSegments = {},
		TransformedValues = {},
		Prefix = "",
		TextSegmentInProgress = "",
		RawSegmentsAreAutocomplete = false
	}

	if type(data.Type) == "table" then
		v.Type = data.Type
	else
		local prefixedUnionType, rawValue2, prefix = Util.ParsePrefixedUnionType(
			command.Cmdr.Registry:GetTypeName(data.Type),
			rawValue
		)

		v.Type = command.Dispatcher.Registry:GetType(prefixedUnionType)
		v.RawValue = rawValue2
		v.Prefix = prefix

		if v.Type == nil then
			error(string.format("%s has an unregistered type %q", v.Name or "<none>", prefixedUnionType or "<none>"))
		end
	end

	setmetatable(v, Argument)

	v:Transform()

	return v
end

function Argument:GetDefaultAutocomplete()
	if not self.Type.Autocomplete then
		return {}
	end

	local autocomplete, v = self.Type.Autocomplete(self:TransformSegment(""))
	return autocomplete, v or {}
end

function Argument:Transform()
	if #self.TransformedValues ~= 0 then
		return
	end

	local v = self.RawValue

	if v == "." and self.Type.Default then
		v = self.Type.Default(self.Executor) or ""
		self.RawSegmentsAreAutocomplete = true
	end

	if v == "?" and self.Type.Autocomplete then
		local defaultAutocomplete, v2 = self:GetDefaultAutocomplete()

		if not v2.IsPartial and #defaultAutocomplete > 0 then
			v = defaultAutocomplete[math.random(1, #defaultAutocomplete)]
			self.RawSegmentsAreAutocomplete = true
		end
	end

	if self.Type.Listable and #self.RawValue > 0 then
		local match = v:match("^%?(%d+)$")

		if match then
			local v2 = tonumber(match)

			if v2 and v2 > 0 then
				local v3 = {}
				local defaultAutocomplete, v4 = self:GetDefaultAutocomplete()

				if not v4.IsPartial and #defaultAutocomplete > 0 then
					for _ = 1, math.min(v2, #defaultAutocomplete) do
						table.insert(v3, table.remove(defaultAutocomplete, math.random(1, #defaultAutocomplete)))
					end

					v = table.concat(v3, ",")
					self.RawSegmentsAreAutocomplete = true
				end
			end
		elseif v == "*" or v == "**" then
			local defaultAutocomplete, v2 = self:GetDefaultAutocomplete()

			if not v2.IsPartial and #defaultAutocomplete > 0 then
				if v == "**" and self.Type.Default then
					local v3 = self.Type.Default(self.Executor) or ""

					for i, v4 in ipairs(defaultAutocomplete) do
						if v4 == v3 then
							table.remove(defaultAutocomplete, i)
						end
					end
				end

				v = table.concat(defaultAutocomplete, ",")

				self.RawSegmentsAreAutocomplete = true
			end
		end

		local v2 = unescapeOperators(v)

		local splitStringSimple = Util.SplitStringSimple(v2, ",")

		local v3 = #splitStringSimple == 0 and { "" } or splitStringSimple

		if v2:sub(#v2, #v2) == "," then
			v3[#v3 + 1] = ""
		end

		for i, v4 in ipairs(v3) do
			self.RawSegments[i] = v4
			self.TransformedValues[i] = { self:TransformSegment(v4) }
		end

		self.TextSegmentInProgress = v3[#v3]
	else
		local v2 = unescapeOperators(v)

		self.RawSegments[1] = unescapeOperators(v2)
		self.TransformedValues[1] = { self:TransformSegment(v2) }
		self.TextSegmentInProgress = self.RawValue
	end
end

function Argument:TransformSegment(p)
	if self.Type.Transform then
		return self.Type.Transform(p, self.Executor)
	end

	return p
end

function Argument:GetTransformedValue(p)
	return unpack(self.TransformedValues[p])
end

function Argument:Validate(p)
	if self.RawValue == nil or #self.RawValue == 0 and self.Required == false then
		return true
	end

	if self.Required and (self.RawSegments[1] == nil or #self.RawSegments[1] == 0) then
		return false, "This argument is required."
	end

	if not (self.Type.Validate or self.Type.ValidateOnce) then
		return true
	end

	for i = 1, #self.TransformedValues do
		if self.Type.Validate then
			local v, v2 = self.Type.Validate(self:GetTransformedValue(i))

			if not v then
				return v, v2 or "Invalid value"
			end
		end

		if not (p and self.Type.ValidateOnce) then
			continue
		end

		local v, v2 = self.Type.ValidateOnce(self:GetTransformedValue(i))

		if not v then
			return v, v2
		end
	end

	return true
end

function Argument:GetAutocomplete()
	if self.Type.Autocomplete then
		return self.Type.Autocomplete(self:GetTransformedValue(#self.TransformedValues))
	end

	return {}
end

function Argument:ParseValue(p)
	if self.Type.Parse then
		return self.Type.Parse(self:GetTransformedValue(p))
	end

	return self:GetTransformedValue(p)
end

function Argument:GetValue()
	if #self.RawValue == 0 and not self.Required and self.Object.Default ~= nil then
		return self.Object.Default
	end

	if not self.Type.Listable then
		return self:ParseValue(1)
	end

	local set = {}

	for i = 1, #self.TransformedValues do
		local value = self:ParseValue(i)

		if type(value) ~= "table" then
			error(("Listable types must return a table from Parse (%s)"):format(self.Type.Name))
		end

		for _, v in pairs(value) do
			set[v] = true
		end
	end

	local result = {}

	for k in pairs(set) do
		result[#result + 1] = k
	end

	return result
end

return Argument