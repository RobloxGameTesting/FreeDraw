local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local remotes = require(ReplicatedStorage.shared.remotes)
local Response = require(ReplicatedStorage.shared.lib.Response)
local dialogsSlice = require(ReplicatedStorage.client.ui.fragments.dialogs.dialogsSlice)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local toastsSlice = require(ReplicatedStorage.client.ui.fragments.toasts.toastsSlice)
local versionHistorySlice = require(ReplicatedStorage.client.ui.fragments.versionHistory.versionHistorySlice)
local String = require(ReplicatedStorage.shared.lib.String)
local getLoadPosition = require(script.Parent.getLoadPosition)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local CreateSaveFileError = require(ReplicatedStorage.shared.enum.error.CreateSaveFileError)
local LoadSaveFileError = require(ReplicatedStorage.shared.enum.error.LoadSaveFileError)
local OverwriteSaveFileError = require(ReplicatedStorage.shared.enum.error.OverwriteSaveFileError)
local LoadAutosaveError = require(ReplicatedStorage.shared.enum.error.LoadAutosaveError)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local getSaveFiles = remotes.Client:Get("getSaveFiles")
local createSaveFile = remotes.Client:Get("createSaveFile")
local loadSaveFile = remotes.Client:Get("loadSaveFile")
local overwriteSaveFile = remotes.Client:Get("overwriteSaveFile")
local renameSaveFile = remotes.Client:Get("renameSaveFile")
local deleteSaveFile = remotes.Client:Get("deleteSaveFile")
local loadAutosave = remotes.Client:Get("loadAutosave")

local function parseSaveFile(p) -- 1 equivalent call inferred from this helper
	local v = Sift.Dictionary.update(p, "createdAt", DateTime.fromUnixTimestamp)
	return (Sift.Dictionary.update(v, "updatedAt", DateTime.fromUnixTimestamp))
end

local actionCreator = Rodux.makeActionCreator("saveFiles/create", function(saveFile)
	return { saveFile = saveFile }
end)

local actionCreator2 = Rodux.makeActionCreator("saveFiles/update", function(id, options)
	return { id = id, options = options }
end)

local actionCreator3 = Rodux.makeActionCreator("saveFiles/delete", function(id)
	return { id = id }
end)

local actionCreator4 = Rodux.makeActionCreator("saveFiles/sync", function(saveFiles, autosave)
	return { saveFiles = saveFiles, autosave = autosave }
end)

local actionCreator5 = Rodux.makeActionCreator("saveFiles/select", function(id)
	return { id = id }
end)

local actionCreator6 = Rodux.makeActionCreator("saveFiles/setLoaded", function(loaded)
	return { loaded = loaded }
end)

local actionCreator7 = Rodux.makeActionCreator("saveFiles/setSearch", function(text)
	return { text = text }
end)

local actionCreator8 = Rodux.makeActionCreator("saveFiles/autosaveDeactivate", function()
	return {}
end)

local function createAsync(trimmed) -- 1 equivalent call inferred from this helper
	return function(object)
		object:dispatch(screensSlice.actions.pushScreen("loading"))
		createSaveFile:CallServerAsync(trimmed):andThen(Response.promisify):andThen(function(p)
			local saveFile = parseSaveFile(p) -- inferred equivalent call
			object:dispatch(actionCreator(saveFile))
			object:dispatch(toastsSlice.thunks.showToast({
				text = Localization.String.new("saveFiles.toast.createSaveFile.success", {
					name = saveFile.name
				}),
				icon = "save"
			}))
		end):catch(function(p)
			object:dispatch(function(object2)
				local v = CreateSaveFileError[p]

				local showToast = toastsSlice.thunks.showToast
				local text

				if v then
					text = Localization.String.new(("saveFiles.toast.createSaveFile.error.%s"):format(v.value))
				else
					text = p
				end

				object2:dispatch(showToast({ text = text, icon = "alert" }))
			end)
		end):finally(function()
			object:dispatch(screensSlice.actions.popScreen())
		end)
	end
end

return {
	reducer = Rodux.createReducer({
		selectedSaveFile = nil,
		saveFiles = {},
		autosave = nil,
		loaded = false,
		search = nil
	}, {
		[actionCreator.name] = function(p, p2)
			return Sift.Dictionary.update(p, "saveFiles", function(p3)
				return Sift.List.push(p3, p2.saveFile)
			end)
		end,
		[actionCreator2.name] = function(p, p2)
			return Sift.Dictionary.update(p, "saveFiles", function(p3)
				return Sift.List.map(p3, function(p4)
					if p4.id == p2.id then
						return Sift.Dictionary.join(p4, p2.options)
					end

					return p4
				end)
			end)
		end,
		[actionCreator3.name] = function(p, p2)
			local join = Sift.Dictionary.join
			local selectedSaveFile

			if p.selectedSaveFile == p2.id then
				selectedSaveFile = Sift.None
			else
				selectedSaveFile = p.selectedSaveFile
			end

			return join(p, {
				selectedSaveFile = selectedSaveFile,
				saveFiles = Sift.List.filter(p.saveFiles, function(p3): boolean
					return p3.id ~= p2.id
				end)
			})
		end,
		[actionCreator5.name] = function(p, p2)
			if p.selectedSaveFile == p2.id then
				return Sift.Dictionary.set(p, "selectedSaveFile", nil)
			end

			return Sift.Dictionary.set(p, "selectedSaveFile", p2.id)
		end,
		[actionCreator4.name] = function(p, p2)
			local where = Sift.List.findWhere(p2.saveFiles, function(p3): boolean
				return p3.id == p.selectedSaveFile
			end)

			local join = Sift.Dictionary.join
			local selectedSaveFile

			if where then
				selectedSaveFile = where.id
			else
				selectedSaveFile = Sift.None
			end

			return join(p, {
				selectedSaveFile = selectedSaveFile,
				saveFiles = p2.saveFiles,
				autosave = p2.autosave
			})
		end,
		[actionCreator6.name] = function(p, p2)
			return Sift.Dictionary.set(p, "loaded", p2.loaded)
		end,
		[actionCreator7.name] = function(p, p2)
			return Sift.Dictionary.set(p, "search", p2.text)
		end,
		[actionCreator8.name] = function(p)
			return Sift.Dictionary.update(p, "autosave", function(p2)
				return Sift.Dictionary.set(p2, "active", false)
			end)
		end
	}),
	middleware = function(callback, object)
		return function(data)
			if data.type == "init" then
				object:dispatch(function(object2)
					getSaveFiles:CallServerAsync():andThen(Response.promisify):andThen(function(p)
						object2:dispatch(actionCreator4(
							Sift.List.map(p.saveFiles, parseSaveFile),
							Sift.Dictionary.update(p.autosave, "saveFile", parseSaveFile)
						))

						object2:dispatch(actionCreator6(true))
					end)
				end)
			elseif data.type == dialogsSlice.actions.interact.name then
				if data.id == "createSaveFile" then
					if data.buttonId == "confirm" then
						object:dispatch(createAsync(String.trim(data.state.name))) -- inferred equivalent call
					end
				elseif data.id == "loadSaveFile" then
					if data.buttonId == "confirm" then
						object:dispatch(screensSlice.actions.popScreen())
						local id = data.context.id
						local v = nil
						object:dispatch(function(object2)
							local state = object2:getState()

							local saveFiles = state.saveFiles.saveFiles
							local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p): boolean
								return p.id == id
							end)]

							object2:dispatch(screensSlice.actions.pushScreen("loading"))
							loadSaveFile:CallServerAsync(id, getLoadPosition(state), v):andThen(Response.promisify):andThen(function()
								object2:dispatch(toastsSlice.thunks.showToast({
									text = Localization.String.new("saveFiles.toast.loadSaveFile.success", {
										name = saveFile.name
									}),
									icon = "save"
								}))
							end):catch(function(p)
								object2:dispatch(function(object3)
									local v2 = LoadSaveFileError[p]

									local showToast = toastsSlice.thunks.showToast
									local text

									if v2 then
										text = Localization.String.new(("saveFiles.toast.loadSaveFile.error.%s"):format(v2.value))
									else
										text = p
									end

									object3:dispatch(showToast({ text = text, icon = "alert" }))
								end)
							end):finally(function()
								object2:dispatch(screensSlice.actions.popScreen())
								object2:dispatch(screensSlice.actions.popScreen())
							end)
						end)
					end
				elseif data.id == "overwriteSaveFile" then
					if data.buttonId == "confirm" then
						object:dispatch(screensSlice.actions.popScreen())
						local id = data.context.id
						object:dispatch(function(object2)
							local saveFiles = object2:getState().saveFiles.saveFiles
							local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p): boolean
								return p.id == id
							end)]

							object2:dispatch(screensSlice.actions.pushScreen("loading"))
							overwriteSaveFile:CallServerAsync(id):andThen(Response.promisify):andThen(function(p)
								object2:dispatch(versionHistorySlice.actions.clearVersions(id))
								object2:dispatch(actionCreator2(id, {
									updatedAt = DateTime.fromUnixTimestamp(p.updatedAt)
								}))
								object2:dispatch(toastsSlice.thunks.showToast({
									text = Localization.String.new("saveFiles.toast.overwriteSaveFile.success", {
										name = saveFile.name
									}),
									icon = "save"
								}))
							end):catch(function(p)
								object2:dispatch(function(object3)
									local v = OverwriteSaveFileError[p]

									local showToast = toastsSlice.thunks.showToast
									local text

									if v then
										text = Localization.String.new(("saveFiles.toast.overwriteSaveFile.error.%s"):format(v.value))
									else
										text = p
									end

									object3:dispatch(showToast({ text = text, icon = "alert" }))
								end)
							end):finally(function()
								object2:dispatch(screensSlice.actions.popScreen())
							end)
						end)
					end
				elseif data.id == "renameSaveFile" then
					if data.buttonId == "confirm" then
						local id = data.context.id
						local trimmed = String.trim(data.state.name)
						object:dispatch(function(object2)
							local saveFiles = object2:getState().saveFiles.saveFiles
							local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p): boolean
								return p.id == id
							end)]

							object2:dispatch(screensSlice.actions.pushScreen("loading"))
							renameSaveFile:CallServerAsync(id, trimmed):andThen(function()
								object2:dispatch(actionCreator2(id, { name = trimmed }))
								object2:dispatch(toastsSlice.thunks.showToast({
									text = Localization.String.new("saveFiles.toast.renameSaveFile", {
										name = saveFile.name,
										newName = trimmed
									}),
									icon = "textEntry"
								}))
							end):finally(function()
								object2:dispatch(screensSlice.actions.popScreen())
							end)
						end)
					end
				elseif data.id == "deleteSaveFile" then
					if data.buttonId == "confirm" then
						local id = data.context.id
						object:dispatch(function(object2)
							local saveFiles = object2:getState().saveFiles.saveFiles
							local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p): boolean
								return p.id == id
							end)]

							object2:dispatch(screensSlice.actions.pushScreen("loading"))
							deleteSaveFile:CallServerAsync(id):andThen(function()
								object2:dispatch(actionCreator3(id))
								object2:dispatch(toastsSlice.thunks.showToast({
									text = Localization.String.new("saveFiles.toast.deleteSaveFile", {
										name = saveFile.name
									}),
									icon = "trash"
								}))
							end):finally(function()
								object2:dispatch(screensSlice.actions.popScreen())
							end)
						end)
					end
				elseif data.id == "loadAutosave" and data.buttonId == "confirm" then
					object:dispatch(function(object2)
						local loadPosition = getLoadPosition(object2:getState())

						object2:dispatch(screensSlice.actions.pushScreen("loading"))
						loadAutosave:CallServerAsync(loadPosition):andThen(Response.promisify):andThen(function()
							object2:dispatch(toastsSlice.thunks.showToast({
								text = Localization.String.new("saveFiles.toast.loadAutosave.success"),
								icon = "save"
							}))

							object2:dispatch(actionCreator8())
						end):catch(function(p)
							object2:dispatch(function(object3)
								local v = LoadAutosaveError[p]

								local showToast = toastsSlice.thunks.showToast
								local text

								if v then
									text = Localization.String.new(("saveFiles.toast.loadAutosave.error.%s"):format(v.value))
								else
									text = p
								end

								object3:dispatch(showToast({ text = text, icon = "alert" }))
							end)
						end):finally(function()
							object2:dispatch(screensSlice.actions.popScreen())
						end)
					end)
				end
			end

			return callback(data)
		end
	end,
	actions = {
		create = actionCreator,
		update = actionCreator2,
		delete = actionCreator3,
		sync = actionCreator4,
		select = actionCreator5,
		setLoaded = actionCreator6,
		setSearch = actionCreator7
	},
	thunks = {
		createDialog = function()
			return function(object)
				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "createSaveFile",
					title = Localization.String.new("saveFiles.dialog.createSaveFile.title"),
					description = Localization.String.new("saveFiles.dialog.createSaveFile.description"),
					embeds = {
						{
							id = "name",
							type = "textArea",
							options = {
								placeholder = Localization.String.new("saveFiles.dialog.createSaveFile.embed.name.placeholder")
							}
						}
					},
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("saveFiles.dialog.createSaveFile.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("saveFiles.dialog.createSaveFile.button.create"),
							style = ButtonStyle.Filled
						}
					}
				}))
			end
		end,
		loadDialog = function(id)
			return function(object)
				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "loadSaveFile",
					title = Localization.String.new("saveFiles.dialog.loadSaveFile.title"),
					description = Localization.String.new("saveFiles.dialog.loadSaveFile.description"),
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("saveFiles.dialog.loadSaveFile.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("saveFiles.dialog.loadSaveFile.button.load"),
							style = ButtonStyle.Filled
						}
					},
					context = { id = id }
				}))
			end
		end,
		overwriteDialog = function(id)
			return function(object)
				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "overwriteSaveFile",
					title = Localization.String.new("saveFiles.dialog.overwriteSaveFile.title"),
					description = Localization.String.new("saveFiles.dialog.overwriteSaveFile.description"),
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("saveFiles.dialog.overwriteSaveFile.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("saveFiles.dialog.overwriteSaveFile.button.save"),
							style = ButtonStyle.Filled
						}
					},
					context = { id = id }
				}))
			end
		end,
		renameDialog = function(id)
			return function(object)
				local saveFiles = object:getState().saveFiles.saveFiles
				local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p): boolean
					return id == p.id
				end)]

				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "renameSaveFile",
					title = Localization.String.new("saveFiles.dialog.renameSaveFile.title"),
					description = Localization.String.new("saveFiles.dialog.renameSaveFile.description"),
					embeds = {
						{
							id = "name",
							type = "textArea",
							options = { placeholder = saveFile.name }
						}
					},
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("saveFiles.dialog.renameSaveFile.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("saveFiles.dialog.renameSaveFile.button.rename"),
							style = ButtonStyle.Filled
						}
					},
					context = { id = id }
				}))
			end
		end,
		deleteDialog = function(id)
			return function(object)
				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "deleteSaveFile",
					title = Localization.String.new("saveFiles.dialog.deleteSaveFile.title"),
					description = Localization.String.new("saveFiles.dialog.deleteSaveFile.description"),
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("saveFiles.dialog.deleteSaveFile.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("saveFiles.dialog.deleteSaveFile.button.delete"),
							style = ButtonStyle.Filled,
							color = colors.red[700]
						}
					},
					context = { id = id }
				}))
			end
		end,
		loadAutosaveDialog = function()
			return function(object)
				object:dispatch(screensSlice.actions.pushScreen("dialog", {
					id = "loadAutosave",
					title = Localization.String.new("saveFiles.dialog.loadAutosave.title"),
					description = Localization.String.new("saveFiles.dialog.loadAutosave.description"),
					buttons = {
						{
							id = "cancel",
							text = Localization.String.new("saveFiles.dialog.loadAutosave.button.cancel")
						},
						{
							id = "confirm",
							text = Localization.String.new("saveFiles.dialog.loadAutosave.button.load"),
							style = ButtonStyle.Filled
						}
					}
				}))
			end
		end,
		createErrorToast = function(p)
			return function(object)
				local v = CreateSaveFileError[p]

				local showToast = toastsSlice.thunks.showToast
				local text

				if v then
					text = Localization.String.new(("saveFiles.toast.createSaveFile.error.%s"):format(v.value))
				else
					text = p
				end

				object:dispatch(showToast({ text = text, icon = "alert" }))
			end
		end,
		loadErrorToast = function(p)
			return function(object)
				local v = LoadSaveFileError[p]

				local showToast = toastsSlice.thunks.showToast
				local text

				if v then
					text = Localization.String.new(("saveFiles.toast.loadSaveFile.error.%s"):format(v.value))
				else
					text = p
				end

				object:dispatch(showToast({ text = text, icon = "alert" }))
			end
		end,
		overwriteErrorToast = function(p)
			return function(object)
				local v = OverwriteSaveFileError[p]

				local showToast = toastsSlice.thunks.showToast
				local text

				if v then
					text = Localization.String.new(("saveFiles.toast.overwriteSaveFile.error.%s"):format(v.value))
				else
					text = p
				end

				object:dispatch(showToast({ text = text, icon = "alert" }))
			end
		end,
		loadAutosaveErrorToast = function(p)
			return function(object)
				local v = LoadAutosaveError[p]

				local showToast = toastsSlice.thunks.showToast
				local text

				if v then
					text = Localization.String.new(("saveFiles.toast.loadAutosave.error.%s"):format(v.value))
				else
					text = p
				end

				object:dispatch(showToast({ text = text, icon = "alert" }))
			end
		end,
		fetchAsync = function()
			return function(object)
				getSaveFiles:CallServerAsync():andThen(Response.promisify):andThen(function(p)
					object:dispatch(actionCreator4(
						Sift.List.map(p.saveFiles, parseSaveFile),
						Sift.Dictionary.update(p.autosave, "saveFile", parseSaveFile)
					))

					object:dispatch(actionCreator6(true))
				end)
			end
		end,
		loadAsync = function(p, p2)
			return function(object)
				local state = object:getState()

				local saveFiles = state.saveFiles.saveFiles
				local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p3): boolean
					return p3.id == p
				end)]

				object:dispatch(screensSlice.actions.pushScreen("loading"))
				loadSaveFile:CallServerAsync(p, getLoadPosition(state), p2):andThen(Response.promisify):andThen(function()
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("saveFiles.toast.loadSaveFile.success", {
							name = saveFile.name
						}),
						icon = "save"
					}))
				end):catch(function(p3)
					object:dispatch(function(object2)
						local v = LoadSaveFileError[p3]

						local showToast = toastsSlice.thunks.showToast
						local text

						if v then
							text = Localization.String.new(("saveFiles.toast.loadSaveFile.error.%s"):format(v.value))
						else
							text = p3
						end

						object2:dispatch(showToast({ text = text, icon = "alert" }))
					end)
				end):finally(function()
					object:dispatch(screensSlice.actions.popScreen())
					object:dispatch(screensSlice.actions.popScreen())
				end)
			end
		end,
		overwriteAsync = function(p)
			return function(object)
				local saveFiles = object:getState().saveFiles.saveFiles
				local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p2): boolean
					return p2.id == p
				end)]

				object:dispatch(screensSlice.actions.pushScreen("loading"))
				overwriteSaveFile:CallServerAsync(p):andThen(Response.promisify):andThen(function(p2)
					object:dispatch(versionHistorySlice.actions.clearVersions(p))
					object:dispatch(actionCreator2(p, {
						updatedAt = DateTime.fromUnixTimestamp(p2.updatedAt)
					}))
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("saveFiles.toast.overwriteSaveFile.success", {
							name = saveFile.name
						}),
						icon = "save"
					}))
				end):catch(function(p2)
					object:dispatch(function(object2)
						local v = OverwriteSaveFileError[p2]

						local showToast = toastsSlice.thunks.showToast
						local text

						if v then
							text = Localization.String.new(("saveFiles.toast.overwriteSaveFile.error.%s"):format(v.value))
						else
							text = p2
						end

						object2:dispatch(showToast({ text = text, icon = "alert" }))
					end)
				end):finally(function()
					object:dispatch(screensSlice.actions.popScreen())
				end)
			end
		end,
		renameAsync = function(p, p2)
			return function(object)
				local saveFiles = object:getState().saveFiles.saveFiles
				local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p3): boolean
					return p3.id == p
				end)]

				object:dispatch(screensSlice.actions.pushScreen("loading"))
				renameSaveFile:CallServerAsync(p, p2):andThen(function()
					object:dispatch(actionCreator2(p, { name = p2 }))
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("saveFiles.toast.renameSaveFile", {
							name = saveFile.name,
							newName = p2
						}),
						icon = "textEntry"
					}))
				end):finally(function()
					object:dispatch(screensSlice.actions.popScreen())
				end)
			end
		end,
		deleteAsync = function(p)
			return function(object)
				local saveFiles = object:getState().saveFiles.saveFiles
				local saveFile = saveFiles[Sift.List.findWhere(saveFiles, function(p2): boolean
					return p2.id == p
				end)]

				object:dispatch(screensSlice.actions.pushScreen("loading"))
				deleteSaveFile:CallServerAsync(p):andThen(function()
					object:dispatch(actionCreator3(p))
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("saveFiles.toast.deleteSaveFile", {
							name = saveFile.name
						}),
						icon = "trash"
					}))
				end):finally(function()
					object:dispatch(screensSlice.actions.popScreen())
				end)
			end
		end,
		loadAutosaveAsync = function()
			return function(object)
				local loadPosition = getLoadPosition(object:getState())

				object:dispatch(screensSlice.actions.pushScreen("loading"))
				loadAutosave:CallServerAsync(loadPosition):andThen(Response.promisify):andThen(function()
					object:dispatch(toastsSlice.thunks.showToast({
						text = Localization.String.new("saveFiles.toast.loadAutosave.success"),
						icon = "save"
					}))

					object:dispatch(actionCreator8())
				end):catch(function(p)
					object:dispatch(function(object2)
						local v = LoadAutosaveError[p]

						local showToast = toastsSlice.thunks.showToast
						local text

						if v then
							text = Localization.String.new(("saveFiles.toast.loadAutosave.error.%s"):format(v.value))
						else
							text = p
						end

						object2:dispatch(showToast({ text = text, icon = "alert" }))
					end)
				end):finally(function()
					object:dispatch(screensSlice.actions.popScreen())
				end)
			end
		end
	}
}