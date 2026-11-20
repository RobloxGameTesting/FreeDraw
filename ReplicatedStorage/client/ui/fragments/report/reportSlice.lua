local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModerationService = game:GetService("ModerationService")

local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local dialogsSlice = require(ReplicatedStorage.client.ui.fragments.dialogs.dialogsSlice)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local remotes = require(ReplicatedStorage.shared.remotes)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local report = remotes.Client:Get("report")

local function submitReportAsync(target, contentId) -- 1 equivalent call inferred from this helper
	return function(object)
		object:dispatch(screensSlice.actions.popScreen())

		task.spawn(function()
			report:SendToServer(target, (ModerationService:CreateReviewableContentKey((Content.fromUri(contentId)))))
		end)
	end
end

return {
	middleware = function(callback, object)
		return function(data)
			if
				data.type == dialogsSlice.actions.interact.name
				and data.id == "confirmReport"
				and data.buttonId == "confirm"
			then
				object:dispatch(submitReportAsync(data.context.target, data.context.contentId)) -- inferred equivalent call
			end

			return callback(data)
		end
	end,
	thunks = {
		confirmReportDialog = function(target, p)
			return function(object)
				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "confirmReport",
					title = Localization.String.new("report.dialog.confirmReport.title"),
					description = Localization.String.new("report.dialog.confirmReport.description"),
					embeds = {
						{
							type = "image",
							options = { id = p, height = 200 }
						}
					},
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("report.dialog.confirmReport.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("report.dialog.confirmReport.button.confirm"),
							style = ButtonStyle.Filled
						}
					},
					context = { target = target, contentId = p }
				}))
			end
		end
	},
	selectors = {
		selectTarget = function(p)
			local currentScreen = screensSlice.selectors.selectCurrentScreen(p)

			if currentScreen.name == "report" then
				return currentScreen.options.target
			end

			return nil
		end
	}
}