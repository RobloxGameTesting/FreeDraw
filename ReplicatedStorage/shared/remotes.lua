local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.packages.Net)
local t = require(ReplicatedStorage.packages.t)

local ServerToClientEvent = Net.Definitions.ServerToClientEvent
local ClientToServerEvent = Net.Definitions.ClientToServerEvent
local ServerAsyncFunction = Net.Definitions.ServerAsyncFunction

local function strict(...)
	return { Net.Middleware.TypeChecking(...) }
end

local v = strict()

local strictInterface = t.strictInterface({
	color = t.Color3,
	transparency = t.numberConstrained(0, 1),
	thickness = t.numberConstrained(0.05, 2)
})

local array = t.array(t.Vector2)

local strictInterface2 = t.strictInterface({
	options = t.strictInterface({
		geometryType = t.string,
		polygonVertices = t.integer,
		polygonInnerRadius = t.number
	}),
	startPoint = t.Vector2,
	endPoint = t.Vector2,
	rotation = t.number
})

local strictInterface3 = t.strictInterface({
	position = t.Vector2,
	rotation = t.number,
	size = t.Vector2
})

return (Net.Definitions.Create({
	showToast = ServerToClientEvent(),
	requestTextFilter = ServerAsyncFunction(strict(t.string)),
	undo = ClientToServerEvent(v),
	redo = ClientToServerEvent(v),
	createLine = ServerAsyncFunction(strict(t.string, strictInterface, array)),
	createShape = ServerAsyncFunction(strict(t.string, strictInterface, strictInterface2)),
	deleteLine = ClientToServerEvent(strict(t.Instance)),
	eraseParts = ServerAsyncFunction(strict(t.string, t.array(t.Instance))),
	getClaims = ServerAsyncFunction(v),
	setClaim = ServerAsyncFunction(strict(strictInterface3)),
	deleteClaim = ServerAsyncFunction(v),
	claimSet = ServerToClientEvent(),
	claimDelete = ServerToClientEvent(),
	clearAll = ClientToServerEvent(v),
	createLayer = ServerAsyncFunction(v),
	renameLayer = ServerAsyncFunction(strict(t.string, t.string)),
	moveLayer = ServerAsyncFunction(strict(t.string, t.number)),
	setLayerVisible = ServerAsyncFunction(strict(t.string, t.boolean)),
	mergeLayer = ServerAsyncFunction(strict(t.string, t.string)),
	deleteLayer = ServerAsyncFunction(strict(t.string)),
	requestVotekick = ServerAsyncFunction(strict(t.Instance, t.string)),
	setVotekickVote = ClientToServerEvent(strict(t.boolean)),
	startVotekick = ServerToClientEvent(),
	updateVotekick = ServerToClientEvent(),
	endVotekick = ServerToClientEvent(),
	updateUserDataStatus = ServerToClientEvent(),
	getSaveFiles = ServerAsyncFunction(v),
	createSaveFile = ServerAsyncFunction(strict(t.string)),
	loadSaveFile = ServerAsyncFunction(strict(t.string, t.Vector2, t.optional(t.string))),
	overwriteSaveFile = ServerAsyncFunction(strict(t.string)),
	renameSaveFile = ServerAsyncFunction(strict(t.string, t.string)),
	deleteSaveFile = ServerAsyncFunction(strict(t.string)),
	loadAutosave = ServerAsyncFunction(strict(t.Vector2)),
	getSaveFileVersions = ServerAsyncFunction(strict(t.string)),
	deleteSaveFileVersion = ServerAsyncFunction(strict(t.string, t.string)),
	getSettings = ServerAsyncFunction(v),
	setSetting = ClientToServerEvent(strict(t.string, t.any)),
	report = ClientToServerEvent(strict(t.instanceOf("Player"), t.string)),
	setProRecipient = ClientToServerEvent(strict(t.optional(t.instanceOf("Player"))))
}))