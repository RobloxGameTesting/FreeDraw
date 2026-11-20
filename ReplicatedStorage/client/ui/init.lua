local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local Root = require(script.Root)
local configureStore = require(script.configureStore)
local configureController = require(script.configureController)

local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
local createElement = Roact.createElement

local store = configureStore()
configureController(store)

local element = createElement(RoactRodux.StoreProvider, { store = store }, {
	Root = createElement(Root)
})

Roact.setGlobalConfig({
	internalTypeChecks = true,
	typeChecks = true,
	elementTracing = true,
	propValidation = true
})

Roact.mount(element, playerGui, "UI")

return { store = store }