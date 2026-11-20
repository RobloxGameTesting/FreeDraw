local function isPro(instance): boolean
	return instance:GetAttribute("proExpiry") > os.time()
end

return isPro