local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)

local Toasts = require(ReplicatedStorage.client.ui.fragments.toasts.Toasts)
local Toolbox = require(ReplicatedStorage.client.ui.fragments.toolbox.Toolbox)
local Options = require(ReplicatedStorage.client.ui.fragments.options.Options)
local Layers = require(ReplicatedStorage.client.ui.fragments.layers.Layers)
local Topbar = require(ReplicatedStorage.client.ui.fragments.topbar.Topbar)
local Toolbar = require(ReplicatedStorage.client.ui.fragments.toolbar.Toolbar)
local Loading = require(ReplicatedStorage.client.ui.fragments.loading.Loading)
local Pro = require(ReplicatedStorage.client.ui.fragments.pro.Pro)
local SaveFiles = require(ReplicatedStorage.client.ui.fragments.saveFiles.SaveFiles)
local Settings = require(ReplicatedStorage.client.ui.fragments.settings.Settings)
local DialogManager = require(ReplicatedStorage.client.ui.fragments.dialogs.DialogManager)
local Rules = require(ReplicatedStorage.client.ui.fragments.rules.Rules)
local PlayerList = require(ReplicatedStorage.client.ui.fragments.playerList.PlayerList)
local VersionHistory = require(ReplicatedStorage.client.ui.fragments.versionHistory.VersionHistory)
local Cursor = require(ReplicatedStorage.client.ui.fragments.cursor.Cursor)
local Identity = require(ReplicatedStorage.client.ui.fragments.identity.Identity)
local Votekick = require(ReplicatedStorage.client.ui.fragments.votekick.Votekick)
local UserData = require(ReplicatedStorage.client.ui.fragments.userData.UserData)
local Report = require(ReplicatedStorage.client.ui.fragments.report.Report)
local Claims = require(ReplicatedStorage.client.ui.fragments.claims.Claims)
local CameraShortcut = require(ReplicatedStorage.client.ui.fragments.camera.CameraShortcut)
local CameraKeybinds = require(ReplicatedStorage.client.ui.fragments.camera.CameraKeybinds)
local Card = require(ReplicatedStorage.client.ui.components.template.Card)
local GUI = require(ReplicatedStorage.client.ui.components.base.GUI)
local ModalGUI = require(ReplicatedStorage.client.ui.components.template.gui.ModalGUI)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)
local PointerType = require(ReplicatedStorage.shared.enum.PointerType)

local v = { frequency = 5, dampingRatio = 0.9 }
local v2 = { frequency = 7, dampingRatio = 1 }

local createElement = Roact.createElement
local createFragment = Roact.createFragment

local function Desktop(props, p)
	local screen = props.screen
	local onClose = props.onClose

	local v3 = (props.camera or props.mouse) and screen.name ~= "report"

	local v4 = RoactFlipper.useSpring(p, v3 and 1 or 0, v)
	local v5 = RoactFlipper.useSpring(p, v3 and 1 or 0, v)
	local v6 = RoactFlipper.useSpring(p, v3 and 1 or 0, v)
	local v7 = RoactFlipper.useSpring(p, screen.name == "report" and 1 or 0, v)

	local v8 = RoactFlipper.useSpring(p, props.camera and 1 or 0, v2)

	local v9 = {
		[1] = nil,
		nil,
		Topbar = createElement(Topbar),
		CursorGUI = createElement(GUI, { zIndex = 1000 }, { Cursor = createElement(Cursor) })
	}
	local v10

	if not props.screenshot then
		local children = {
			IdentityGUI = createElement(GUI, nil, { Identity = createElement(Identity) }),
			ToastsGUI = createElement(GUI, { inset = true, zIndex = 50 }, {
				Toasts = createElement(Toasts, {
					size = UDim2.new(0, 350, 0, 0),
					position = UDim2.new(1, -32, 0, 32),
					anchorPoint = Vector2.new(1, 0)
				})
			}),
			ToolbarGUI = createElement(GUI, nil, {
				Toolbar = createElement(Toolbar, {
					groups = p.useMemo(function()
						return {
							"pro",
							"history",
							"screens",
							"actions",
							not props.mouse and props.camera and "camera" or nil
						}
					end, { props.mouse, props.camera }),
					position = UDim2.new(0.5, 0, 0, 30),
					anchorPoint = Vector2.new(0.5, 0.5)
				})
			}),
			PlayerListGUI = createElement(GUI, { inset = true, zIndex = 5 }, {
				PlayerList = createElement(PlayerList, {
					size = UDim.new(0, 200),
					position = UDim2.new(1, -4, 0, 0),
					anchorPoint = Vector2.new(1, 0)
				})
			}),
			VotekickGUI = createElement(GUI, { inset = true, zIndex = 50 }, {
				Votekick = createElement(Votekick, {
					alwaysExpanded = true,
					size = UDim.new(0, 360),
					position = UDim2.new(1, -16, 0, 16),
					anchorPoint = Vector2.new(1, 0)
				})
			}),
			UserDataGUI = createElement(GUI, { zIndex = 5 }, {
				UserData = createElement(UserData, {
					position = UDim2.new(0.5, 0, 0, 72),
					anchorPoint = Vector2.new(0.5, 0)
				})
			}),
			CameraShortcutGUI = 0,
			ReportGUI = 0,
			ToolboxGUI = 0,
			OptionsGUI = 0,
			LayersGUI = 0,
			DialogManager = 0,
			Loading = 0,
			SaveFilesGUI = 0,
			SettingsGUI = 0,
			RulesGUI = 0,
			ProGUI = 0,
			VersionHistoryGUI = 0
		}
		local cameraShortcutGUI

		if not props.mouse then
			cameraShortcutGUI = createElement(GUI, { inset = true }, {
				CameraShortcut = createElement(CameraShortcut, {
					active = not props.camera,
					position = UDim2.new(0.5, 0, 1, -100),
					anchorPoint = Vector2.new(0.5, 1)
				})
			})
		end

		children.CameraShortcutGUI = cameraShortcutGUI

		local v11 = {
			visible = v7:map(function(p2): boolean
				return p2 > 0.025
			end)
		}
		local target

		if screen.name == "report" then
			target = screen.options.target
		end

		children.ReportGUI = createElement(GUI, v11, {
			Report = createElement(Report, {
				target = target,
				transparency = p.useMemo(function()
					return Binding.mapLerp(v7, 1, 0)
				end, { v7 }),
				position = p.useMemo(function()
					return v7:map(function(p2)
						return UDim2.new(0.5, 0, 1, -Number.lerp(32, 64, p2))
					end)
				end, { v7 }),
				anchorPoint = Vector2.new(0.5, 1)
			})
		})

		children.ToolboxGUI = createElement(GUI, {
			visible = v4:map(function(p2): boolean
				return p2 > 0.025
			end)
		}, {
			Toolbox = createElement(Toolbox, {
				transparency = p.useMemo(function()
					return Binding.mapLerp(v4, 1, 0)
				end, { v4 }),
				position = p.useMemo(function()
					return v4:map(function(p2)
						return UDim2.new(0.5, 0, 1, -(32 + Number.lerp(0, 32, p2)))
					end)
				end, { v4 }),
				anchorPoint = Vector2.new(0.5, 0.5)
			})
		})

		children.OptionsGUI = createElement(GUI, {
			zIndex = 2,
			visible = v5:map(function(p2): boolean
				return p2 > 0.025
			end)
		}, {
			Options = createElement(Card, {
				transparency = p.useMemo(function()
					return Binding.mapLerp(v5, 1, 0)
				end, { v5 }),
				position = p.useMemo(function()
					return v5:map(function(p2)
						return UDim2.new(0, Number.lerp(0, 32, p2), 1, -32)
					end)
				end, { v5 }),
				anchorPoint = Vector2.new(0, 1)
			}, {
				Options = createElement(Options, { width = 240 })
			})
		})

		local v12 = {
			zIndex = 2,
			visible = v6:map(function(p2): boolean
				return p2 > 0.025
			end)
		}

		local v13 = {
			Layers = createElement(Card, {
				transparency = p.useMemo(function()
					return Binding.mapLerp(v6, 1, 0)
				end, { v6 }),
				position = p.useMemo(function()
					return v6:map(function(p2)
						return UDim2.new(1, Number.lerp(0, -32, p2), 1, -32)
					end)
				end, { v6 }),
				anchorPoint = Vector2.new(1, 1)
			}, {
				Layers = createElement(Layers, { size = UDim2.new(0, 240, 0, 280) })
			}),
			CameraKeybinds = 0
		}
		local cameraKeybinds

		if UserInputService.KeyboardEnabled then
			cameraKeybinds = createElement(CameraKeybinds, {
				transparency = p.useMemo(function()
					return Binding.mapLerp(v8, 1, 0)
				end, { v8 }),
				position = UDim2.new(1, -32, 1, -328),
				anchorPoint = Vector2.new(1, 1)
			})
		end

		v13.CameraKeybinds = cameraKeybinds
		children.LayersGUI = createElement(GUI, v12, v13)
		local dialog

		if screen.name == "dialog" then
			dialog = screen
		end

		children.DialogManager = createElement(DialogManager, { dialog = dialog, onClose = onClose })

		children.Loading = createElement(Loading, {
			active = screen.name == "loading"
		})

		children.SaveFilesGUI = createElement(ModalGUI, {
			active = screen.name == "saveFiles",
			dontUnload = true,
			size = UDim2.fromOffset(720, 440),
			onClose = onClose
		}, { SaveFiles = createElement(SaveFiles) })

		children.SettingsGUI = createElement(ModalGUI, {
			active = screen.name == "settings",
			size = UDim2.fromOffset(600, 460),
			onClose = onClose
		}, { Settings = createElement(Settings) })

		children.RulesGUI = createElement(ModalGUI, {
			active = screen.name == "rules",
			onClose = onClose
		}, {
			Rules = createElement(Rules, { width = 540 })
		})

		local v14 = {
			active = screen.name == "pro",
			onClose = onClose
		}

		local v15 = {
			active = screen.name == "pro",
			recipient = 0,
			width = 360
		}
		local recipient

		if screen.name == "pro" then
			recipient = screen.options.recipient
		end

		v15.recipient = recipient
		children.ProGUI = createElement(ModalGUI, v14, { Pro = createElement(Pro, v15) })

		children.VersionHistoryGUI = createElement(ModalGUI, {
			active = screen.name == "versionHistory",
			size = UDim2.fromOffset(360, 400),
			onClose = onClose
		}, { VersionHistory = createElement(VersionHistory) })
		v10 = createFragment(children)
	end

	v9[1] = v10
	v9.Claims = createElement(Claims)
	return createFragment(v9)
end

local v3 = hook(Desktop, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		camera = p.camera.enabled,
		mouse = p.platform.pointer == PointerType.Mouse
	}
end)(v3))