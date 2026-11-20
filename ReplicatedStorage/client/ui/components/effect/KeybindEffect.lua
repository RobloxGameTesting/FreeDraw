local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hook = require(ReplicatedStorage.shared.util.hook)

local function KeybindEffect(p, p2)
	p2.useEffect(function()
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and table.find(p.keys, input.KeyCode) then
				p.onPress(input)
			end
		end)

		return function()
			inputBeganConnection:Disconnect()
		end
	end, { p.keys, p.onPress })
end

return (hook(KeybindEffect, { componentType = "PureComponent" }))