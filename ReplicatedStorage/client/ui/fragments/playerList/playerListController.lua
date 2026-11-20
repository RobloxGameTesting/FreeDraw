local UserInputService = game:GetService("UserInputService")

local playerListSlice = require(script.Parent.playerListSlice)

local function playerListController(object)
	local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == Enum.KeyCode.Tab then
			object:dispatch(playerListSlice.actions.toggleOpen())
		end
	end)

	return function()
		inputBeganConnection:Disconnect()
	end
end

return playerListController