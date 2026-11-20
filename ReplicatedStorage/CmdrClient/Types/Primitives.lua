local Util = require(script.Parent.Parent.Shared.Util)

local v = {
	Validate = function(p): boolean
		return p ~= nil
	end,
	Parse = function(p)
		return (tostring(p))
	end
}

local v2 = {
	Transform = function(p)
		return (tonumber(p))
	end,
	Validate = function(p): boolean
		return p ~= nil
	end,
	Parse = function(p)
		return p
	end
}

local v3 = {
	Transform = function(p)
		return (tonumber(p))
	end,
	Validate = function(p): (boolean, string)
		return p ~= nil and p == math.floor(p), "Only whole numbers are valid."
	end,
	Parse = function(p)
		return p
	end
}

local dictionary = Util.MakeDictionary({
	"true",
	"t",
	"yes",
	"y",
	"on",
	"enable",
	"enabled",
	"1",
	"+"
})
local dictionary2 = Util.MakeDictionary({
	"false",
	"f",
	"no",
	"n",
	"off",
	"disable",
	"disabled",
	"0",
	"-"
})

local v4 = {
	Transform = function(value)
		return value:lower()
	end,
	Validate = function(p): (boolean, string)
		return dictionary[p] ~= nil or dictionary2[p] ~= nil, "Please use true/yes/on or false/no/off."
	end,
	Parse = function(p): nil | boolean
		if dictionary[p] then
			return true
		end

		return if dictionary2[p] then false else nil
	end
}

return function(registry)
	registry:RegisterType("string", v)
	registry:RegisterType("number", v2)
	registry:RegisterType("integer", v3)
	registry:RegisterType("boolean", v4)

	registry:RegisterType("strings", Util.MakeListableType(v))
	registry:RegisterType("numbers", Util.MakeListableType(v2))
	registry:RegisterType("integers", Util.MakeListableType(v3))
	registry:RegisterType("booleans", Util.MakeListableType(v4))
end