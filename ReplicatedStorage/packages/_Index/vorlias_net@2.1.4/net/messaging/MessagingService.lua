local RunService = game:GetService("RunService")
local MessagingService = game:GetService("MessagingService")

local v2 = {}
local v = {
	PublishAsync = function(_, p, p2)
		local v = v2[p]

		if v then
			v:Fire({ Sent = tick(), Data = p2 })
		end
	end,
	SubscribeAsync = function(_, name, onEvent)
		local v = v2[name]

		if not v then
			v = Instance.new("BindableEvent")
			v.Parent = script
			v.Name = name
			v2[name] = v
		end

		return v.Event:Connect(onEvent)
	end
}

return if RunService:IsStudio() then v else MessagingService