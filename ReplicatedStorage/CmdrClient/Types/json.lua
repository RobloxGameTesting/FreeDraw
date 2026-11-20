local HttpService = game:GetService("HttpService")

return function(registry)
	registry:RegisterType("json", {
		Validate = function(json)
			return pcall(function()
				return HttpService:JSONDecode(json)
			end)
		end,
		Parse = function(json)
			return HttpService:JSONDecode(json)
		end
	})
end