local createUseBinding = require(script.createUseBinding)
local createUseCallback = require(script.createUseCallback)
local createUseContext = require(script.createUseContext)
local createUseEffect = require(script.createUseEffect)
local createUseMemo = require(script.createUseMemo)
local createUseReducer = require(script.createUseReducer)
local createUseState = require(script.createUseState)
local createUseValue = require(script.createUseValue)
local dependenciesDifferent = require(script.dependenciesDifferent)

local function createHooks(roact, p)
	local useEffect = createUseEffect(p)
	local useState = createUseState(p)
	local useValue = createUseValue(p)

	local useBinding = createUseBinding(roact, useValue)
	local useContext = createUseContext(p, useEffect, useState)
	local useMemo = createUseMemo(useValue)

	local useCallback = createUseCallback(useMemo)

	return {
		Roact = roact,
		useBinding = useBinding,
		useCallback = useCallback,
		useContext = useContext,
		useEffect = useEffect,
		useMemo = useMemo,
		useReducer = createUseReducer(useCallback, useState),
		useState = useState,
		useValue = useValue
	}
end

return {
	new = function(p)
		return function(callback, p2)
			assert(typeof(callback) == "function", "Hooked components must be functions.")

			local v = p2 == nil and {} or p2

			local componentType = v.componentType
			local name = v.name or debug.info(callback, "n")

			local v2 = nil

			if componentType == nil or componentType == "Component" then
				v2 = p.Component:extend(name)
			elseif componentType == "PureComponent" then
				v2 = p.PureComponent:extend(name)
			else
				error(string.format(
					"'%s' is not a valid componentType. componentType must either be nil, 'Component', or 'PureComponent'",
					(tostring(componentType))
				))
			end

			v2.defaultProps = v.defaultProps
			v2.validateProps = v.validateProps

			function v2:init()
				self.defaultStateValues = {}
				self.effectDependencies = {}
				self.effects = {}
				self.unmountEffects = {}

				self.hooks = createHooks(p, self)
			end

			function v2:runEffects()
				for i = 1, self.hookCounter do
					local effect = self.effects[i]

					if effect == nil then
						continue
					end

					local v3, v4 = unpack(effect)

					if v4 ~= nil then
						local effectDependency = self.effectDependencies[i]

						if effectDependency ~= nil and not dependenciesDifferent(v4, effectDependency) then
							continue
						end

						self.effectDependencies[i] = v4
					end

					local unmountEffect = self.unmountEffects[i]

					if unmountEffect ~= nil then
						unmountEffect()
					end

					self.unmountEffects[i] = v3()
				end
			end

			function v2:didMount()
				self:runEffects()
			end

			function v2:didUpdate()
				self:runEffects()
			end

			function v2.willUnmount(p3)
				for i = 1, p3.hookCounter do
					local unmountEffect = p3.unmountEffects[i]

					if unmountEffect ~= nil then
						unmountEffect()
					end
				end
			end

			function v2:render()
				self.hookCounter = 0

				return callback(self.props, self.hooks)
			end

			return v2
		end
	end
}