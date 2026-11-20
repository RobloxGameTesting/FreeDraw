local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local v = {
	Color3 = true,
	UDim = true,
	UDim2 = true,
	Vector2 = true,
	Vector3 = true
}

local function is(p) -- 4 equivalent calls inferred from this helper
	return tostring(p):match("^RoactBinding(.*)$") and true or false
end

local function mapAny(object, fn) -- 1 equivalent call inferred from this helper
	if is(object) then -- inferred equivalent call
		return object:map(fn)
	end

	if object == nil then
		return nil
	end

	return fn(object)
end

local Binding = {}
Binding.is = is

function Binding.toBinding(p)
	if is(p) then -- inferred equivalent call
		return p
	end

	return Roact.createBinding(p)
end

Binding.mapAny = mapAny

function Binding.getValueAny(object)
	if is(object) then -- inferred equivalent call
		return object:getValue()
	end

	return object
end

function Binding.joinAny(items)
	local v2 = {}
	local v3 = {}

	for k, item in items do
		if is(item) then -- inferred equivalent call
			v2[k] = item
		else
			v3[k] = item
		end
	end

	return Roact.joinBindings(v2):map(function(p)
		return Sift.Dictionary.join(p, v3)
	end)
end

function Binding.mapLerp(object, object2, p)
	local typeName = typeof(object2)

	if typeName ~= typeof(p) then
		error(("Type mismatch between values (%s, %s)"):format(typeName, (typeof(p))))
	end

	local function fn(p2)
		if typeName == "number" then
			return object2 + (p - object2) * p2
		end

		if v[typeName] then
			return object2:lerp(p, p2)
		end

		error(("Unable to interpolate type %s"):format(typeName))
	end

	return mapAny(object, fn) or object2 -- inferred equivalent call
end

function Binding.mapPluck(p, p2)
	return mapAny(p, function(p3)
		return p3[p2]
	end)
end

function Binding.createBindingConverter(p, items)
	local bindingConverter = Roact.Component:extend(("BindingConverter(%s)"):format(p.__componentName))

	function bindingConverter:init()
		self.bindings = {}
		self.bindingSetters = {}

		for _, item in items do
			local binding, v2 = Roact.createBinding(self.props[item])
			self.bindings[item] = binding
			self.bindingSetters[item] = v2
		end
	end

	function bindingConverter.render(props)
		for _, item in items do
			props.bindingSetters[item](props.props[item])
		end

		return Roact.createElement(p, Sift.Dictionary.join(props.props, props.bindings))
	end

	return bindingConverter
end

return Binding