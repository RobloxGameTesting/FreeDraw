local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local settingsController = require(script.Parent.fragments.settings.settingsController)
local variablesController = require(script.Parent.fragments.variables.variablesController)
local toolboxController = require(script.Parent.fragments.toolbox.toolboxController)
local layersController = require(script.Parent.fragments.layers.layersController)
local platformController = require(script.Parent.fragments.platform.platformController)
local cameraController = require(script.Parent.fragments.camera.cameraController)
local playersController = require(script.Parent.fragments.players.playersController)
local playerListController = require(script.Parent.fragments.playerList.playerListController)
local votekickController = require(script.Parent.fragments.votekick.votekickController)
local inputController = require(script.Parent.fragments.input.inputController)
local identityController = require(script.Parent.fragments.identity.identityController)
local userDataController = require(script.Parent.fragments.userData.userDataController)
local claimsController = require(script.Parent.fragments.claims.claimsController)
local blinkController = require(script.Parent.fragments.blink.blinkController)
local toastsController = require(script.Parent.fragments.toasts.toastsController)

local function configureController(p)
	local v = Maid.new({
		settingsController(p),
		variablesController(p),
		toolboxController(p),
		layersController(p),
		platformController(p),
		cameraController(p),
		playersController(p),
		playerListController(p),
		votekickController(p),
		inputController(p),
		identityController(p),
		userDataController(p),
		claimsController(p),
		blinkController(p),
		toastsController(p)
	})

	return function()
		v:clean()
	end
end

return configureController