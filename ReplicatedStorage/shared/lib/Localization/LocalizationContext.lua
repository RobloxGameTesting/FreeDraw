local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)

local LocalizationContext = {}
LocalizationContext.__index = LocalizationContext

function LocalizationContext.new(provider)
	local object = setmetatable({ provider = provider, context = Roact.createContext(nil) }, LocalizationContext)

	object.component = hook(function(props, props2)
		local state, setState = props2.useState(object.provider.locale)
		props2.useEffect(function()
			local onLocaleChangeConnection = object.provider.onLocaleChange:connect(setState)
			return function()
				onLocaleChangeConnection:disconnect()
			end
		end)

		return Roact.createElement(object.context.Provider, {
			value = props2.useMemo(function()
				return { provider = object.provider, locale = state }
			end, { state })
		}, props[Roact.Children])
	end)

	return object
end

function LocalizationContext.useProvider(p, p2)
	return p2.useContext(p.context).provider
end

function LocalizationContext.useLocale(p, p2)
	return p2.useContext(p.context).locale
end

return LocalizationContext