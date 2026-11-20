local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local variablesSlice = require(script.Parent.fragments.variables.variablesSlice)
local screensSlice = require(script.Parent.fragments.screens.screensSlice)
local toastsSlice = require(script.Parent.fragments.toasts.toastsSlice)
local toolboxSlice = require(script.Parent.fragments.toolbox.toolboxSlice)
local optionsSlice = require(script.Parent.fragments.options.optionsSlice)
local platformSlice = require(script.Parent.fragments.platform.platformSlice)
local layersSlice = require(script.Parent.fragments.layers.layersSlice)
local toolbarSlice = require(script.Parent.fragments.toolbar.toolbarSlice)
local saveFilesSlice = require(script.Parent.fragments.saveFiles.saveFilesSlice)
local cameraSlice = require(script.Parent.fragments.camera.cameraSlice)
local playersSlice = require(script.Parent.fragments.players.playersSlice)
local playerListSlice = require(script.Parent.fragments.playerList.playerListSlice)
local versionHistorySlice = require(script.Parent.fragments.versionHistory.versionHistorySlice)
local votekickSlice = require(script.Parent.fragments.votekick.votekickSlice)
local navigationSlice = require(script.Parent.fragments.navigation.navigationSlice)
local panelsSlice = require(script.Parent.fragments.panels.panelsSlice)
local identitySlice = require(script.Parent.fragments.identity.identitySlice)
local userDataSlice = require(script.Parent.fragments.userData.userDataSlice)
local screenshotSlice = require(script.Parent.fragments.screenshot.screenshotSlice)
local rulesSlice = require(script.Parent.fragments.rules.rulesSlice)
local claimsSlice = require(script.Parent.fragments.claims.claimsSlice)
local reportSlice = require(script.Parent.fragments.report.reportSlice)
local settingsSlice = require(script.Parent.fragments.settings.settingsSlice)

local combineReducers = Rodux.combineReducers({
	variables = variablesSlice.reducer,
	settings = settingsSlice.reducer,
	screens = screensSlice.reducer,
	toasts = toastsSlice.reducer,
	toolbox = toolboxSlice.reducer,
	options = optionsSlice.reducer,
	platform = platformSlice.reducer,
	layers = layersSlice.reducer,
	toolbar = toolbarSlice.reducer,
	saveFiles = saveFilesSlice.reducer,
	camera = cameraSlice.reducer,
	players = playersSlice.reducer,
	playerList = playerListSlice.reducer,
	versionHistory = versionHistorySlice.reducer,
	votekick = votekickSlice.reducer,
	navigation = navigationSlice.reducer,
	panels = panelsSlice.reducer,
	identity = identitySlice.reducer,
	userData = userDataSlice.reducer,
	screenshot = screenshotSlice.reducer,
	claims = claimsSlice.reducer
})

local function configureStore()
	local store = Rodux.Store.new(combineReducers, nil, {
		Rodux.thunkMiddleware,
		settingsSlice.middleware,
		platformSlice.middleware,
		saveFilesSlice.middleware,
		playersSlice.middleware,
		versionHistorySlice.middleware,
		toolbarSlice.middleware,
		votekickSlice.middleware,
		playerListSlice.middleware,
		cameraSlice.middleware,
		rulesSlice.middleware,
		claimsSlice.middleware,
		reportSlice.middleware
	})

	store:dispatch({ type = "init" })

	return store
end

return configureStore