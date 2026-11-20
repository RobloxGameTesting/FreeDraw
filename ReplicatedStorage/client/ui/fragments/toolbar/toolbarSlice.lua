local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = require(ReplicatedStorage.shared.remotes)
local dialogsSlice = require(ReplicatedStorage.client.ui.fragments.dialogs.dialogsSlice)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local undo = remotes.Client:Get("undo")
local redo = remotes.Client:Get("redo")
local clearAll = remotes.Client:Get("clearAll")

return {
	reducer = nil,
	middleware = function(callback, object)
		return function(data)
			if
				data.type == dialogsSlice.actions.interact.name
				and data.id == "clearAll"
				and data.buttonId == "confirm"
			then
				object:dispatch(function()
					clearAll:SendToServer()
				end)
			end

			return callback(data)
		end
	end,
	thunks = {
		undo = function()
			return function()
				undo:SendToServer()
			end
		end,
		redo = function()
			return function()
				redo:SendToServer()
			end
		end,
		clearAll = function()
			return function()
				clearAll:SendToServer()
			end
		end,
		clearAllDialog = function()
			return function(object)
				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "clearAll",
					title = Localization.String.new("toolbar.dialog.clearAll.title"),
					description = Localization.String.new("toolbar.dialog.clearAll.description"),
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("toolbar.dialog.clearAll.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("toolbar.dialog.clearAll.button.clearAll"),
							style = ButtonStyle.Filled,
							color = colors.red[700]
						}
					}
				}))
			end
		end
	}
}