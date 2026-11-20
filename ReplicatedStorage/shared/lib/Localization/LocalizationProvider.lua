local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.packages.Promise)

local LocalizationString = require(script.Parent.LocalizationString)
local Signal = require(ReplicatedStorage.shared.class.Signal)

local v = LocalizationService:GetChildren()[1]
local translator = v:GetTranslator(v.Name)

local LocalizationProvider = {}
LocalizationProvider.__index = LocalizationProvider

function LocalizationProvider.create(p)
	local object = setmetatable(
		{ locale = v.Name, translator = translator, onLocaleChange = Signal.new() },
		LocalizationProvider
	)

	if p then
		Promise.try(function()
			return LocalizationService:GetTranslatorForPlayerAsync(p)
		end):andThen(function(translator2)
			object.translator = translator2
			object.locale = translator2.LocaleId
			object.onLocaleChange:fire(object.locale)

			translator2:GetPropertyChangedSignal("LocaleId"):Connect(function()
				object.locale = translator2.LocaleId
				object.onLocaleChange:fire(object.locale)
			end)
		end)
	end

	return object
end

function LocalizationProvider:formatByKey(p, p2)
	local success, result

	if self.translator then
		success, result = pcall(function()
			return self.translator:FormatByKey(p, p2)
		end)
	else
		success = false
	end

	if not success then
		success, result = pcall(function()
			return translator:FormatByKey(p, p2)
		end)
	end

	if not success then
		warn(`Failed to find localization for {p}`)
		result = p
	end

	return result
end

function LocalizationProvider:resolve(p)
	if not LocalizationString.is(p) then
		return p
	end

	local v2 = {}

	if p.arguments then
		for k, argument in p.arguments do
			v2[k] = self:resolve(argument)
		end
	end

	return self:formatByKey(p.key, v2)
end

return LocalizationProvider