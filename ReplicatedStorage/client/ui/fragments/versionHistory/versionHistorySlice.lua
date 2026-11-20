local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local remotes = require(ReplicatedStorage.shared.remotes)
local Response = require(ReplicatedStorage.shared.lib.Response)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local dialogsSlice = require(ReplicatedStorage.client.ui.fragments.dialogs.dialogsSlice)
local toastsSlice = require(ReplicatedStorage.client.ui.fragments.toasts.toastsSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local getSaveFileVersions = remotes.Client:Get("getSaveFileVersions")
local deleteSaveFileVersion = remotes.Client:Get("deleteSaveFileVersion")

local actionCreator = Rodux.makeActionCreator("versionHistory/pushVersions", function(id, versions)
	return { id = id, versions = versions }
end)

local actionCreator2 = Rodux.makeActionCreator("versionHistory/clearVersions", function(id)
	return { id = id }
end)

local actionCreator3 = Rodux.makeActionCreator("versionHistory/deleteVersion", function(id, versionId)
	return { id = id, versionId = versionId }
end)

return {
	reducer = Rodux.createReducer({}, {
		[actionCreator.name] = function(p, p2)
			local v = p[p2.id] or {}
			local joined = Sift.List.join(v, p2.versions)
			return Sift.Dictionary.set(p, p2.id, joined)
		end,
		[actionCreator2.name] = function(p, p2)
			return Sift.Dictionary.removeKey(p, p2.id)
		end,
		[actionCreator3.name] = function(p, p2)
			return Sift.Dictionary.update(p, p2.id, function(p3)
				return Sift.List.filter(p3, function(p4): boolean
					return p4.id ~= p2.versionId
				end)
			end)
		end
	}),
	middleware = function(callback, p)
		return function(data)
			if
				data.type == dialogsSlice.actions.interact.name
				and data.id == "deleteSaveFileVersion"
				and data.buttonId == "confirm"
			then
				local id = data.context.id
				local versionId = data.context.versionId
				p:dispatch(function(object)
					local saveFiles = object:getState().saveFiles.saveFiles
					local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p2): boolean
						return p2.id == id
					end)]

					object:dispatch(screensSlice.actions.pushScreen("loading"))
					deleteSaveFileVersion:CallServerAsync(id, versionId):andThen(Response.promisify):andThen(function()
						object:dispatch(actionCreator3(id, versionId))
						object:dispatch(toastsSlice.thunks.showToast({
							text = Localization.String.new("versionHistory.toast.deleteSaveFileVersion.success", {
								name = saveFile.name,
								version = versionId
							}),
							icon = "save"
						}))
					end):catch(function()
						object:dispatch(toastsSlice.thunks.showToast({
							text = Localization.String.new("versionHistory.toast.deleteSaveFileVersion.error", {
								name = saveFile.name,
								version = versionId
							}),
							icon = "alert"
						}))
					end):finally(function()
						object:dispatch(screensSlice.actions.popScreen())
					end)
				end)
			end

			return callback(data)
		end
	end,
	actions = {
		pushVersions = actionCreator,
		clearVersions = actionCreator2,
		deleteVersion = actionCreator3
	},
	thunks = {
		fetchVersionsAsync = function(p)
			return function(object)
				getSaveFileVersions:CallServerAsync(p):andThen(Response.promisify):andThen(function(p2)
					object:dispatch(actionCreator(p, p2))
				end)
			end
		end,
		ensureVersionsAsync = function(p)
			return function(object)
				if not object:getState().versionHistory[p] then
					local v = p
					object:dispatch(function(object2)
						getSaveFileVersions:CallServerAsync(v):andThen(Response.promisify):andThen(function(p2)
							object2:dispatch(actionCreator(v, p2))
						end)
					end)
				end
			end
		end,
		deleteVersionAsync = function(p, version)
			return function(object)
				local saveFiles = object:getState().saveFiles.saveFiles
				local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p2): boolean
					return p2.id == p
				end)]

				object:dispatch(screensSlice.actions.pushScreen("loading"))
				deleteSaveFileVersion:CallServerAsync(p, version):andThen(Response.promisify):andThen(function()
					object:dispatch(actionCreator3(p, version))
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("versionHistory.toast.deleteSaveFileVersion.success", {
							name = saveFile.name,
							version = version
						}),
						icon = "save"
					}))
				end):catch(function()
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("versionHistory.toast.deleteSaveFileVersion.error", {
							name = saveFile.name,
							version = version
						}),
						icon = "alert"
					}))
				end):finally(function()
					object:dispatch(screensSlice.actions.popScreen())
				end)
			end
		end
	}
}