return {
	isActive = function(p): boolean
		local userInputState = p.UserInputState

		return userInputState == Enum.UserInputState.Begin or userInputState == Enum.UserInputState.Change
	end
}