local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Toasts = require(ReplicatedStorage.client.ui.fragments.toasts.Toasts)
local Toolbox = require(ReplicatedStorage.client.ui.fragments.toolbox.Toolbox)
local Cursor = require(ReplicatedStorage.client.ui.fragments.cursor.Cursor)
local Identity = require(ReplicatedStorage.client.ui.fragments.identity.Identity)
local Toolbar = require(ReplicatedStorage.client.ui.fragments.toolbar.Toolbar)
local Topbar = require(ReplicatedStorage.client.ui.fragments.topbar.Topbar)
local Votekick = require(ReplicatedStorage.client.ui.fragments.votekick.Votekick)
local DialogManager = require(ReplicatedStorage.client.ui.fragments.dialogs.DialogManager)
local PlayerList = require(ReplicatedStorage.client.ui.fragments.playerList.PlayerList)
local Loading = require(ReplicatedStorage.client.ui.fragments.loading.Loading)
local SaveFiles = require(ReplicatedStorage.client.ui.fragments.saveFiles.SaveFiles)
local Settings = require(ReplicatedStorage.client.ui.fragments.settings.Settings)
local Pro = require(ReplicatedStorage.client.ui.fragments.pro.Pro)
local Navigation = require(ReplicatedStorage.client.ui.fragments.navigation.Navigation)
local Rules = require(ReplicatedStorage.client.ui.fragments.rules.Rules)
local Panels = require(ReplicatedStorage.client.ui.fragments.panels.Panels)
local UserData = require(ReplicatedStorage.client.ui.fragments.userData.UserData)
local VersionHistory = require(ReplicatedStorage.client.ui.fragments.versionHistory.VersionHistory)
local Claims = require(ReplicatedStorage.client.ui.fragments.claims.Claims)
local GUI = require(ReplicatedStorage.client.ui.components.base.GUI)
local SlideGUI = require(ReplicatedStorage.client.ui.components.template.gui.SlideGUI)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Number = require(ReplicatedStorage.shared.lib.Number)

local v = { frequency = 5, dampingRatio = 0.9 }

local createElement = Roact.createElement
local createFragment = Roact.createFragment

local function Phone(props, p)
	local screen = props.screen
	local onClose = props.onClose

	local v2 = RoactFlipper.useSpring(p, props.drawing and 0 or 1, v)
	local v3 = RoactFlipper.useSpring(p, props.drawing and 0 or 1, v)

	local v4 = RoactFlipper.useSpring(p, props.drawing and 1 or 0, v)
	local v5 = RoactFlipper.useSpring(p, props.drawing and 1 or 0, v)
	local v6 = RoactFlipper.useSpring(p, props.drawing and 1 or 0, v)

	local v7 = {
		[1] = nil,
		nil,
		Topbar = createElement(Topbar),
		CursorGUI = createElement(GUI, { zIndex = 1000 }, { Cursor = createElement(Cursor) })
	}
	local v8

	if not props.screenshot then
		local children = {
			IdentityGUI = createElement(GUI, nil, { Identity = createElement(Identity) }),
			ToastsGUI = createElement(GUI, { zIndex = 50, inset = true }, {
				Toasts = createElement(Toasts, {
					size = UDim2.new(1, -12, 0, 0),
					position = UDim2.new(0.5, 0, 0, 6),
					anchorPoint = Vector2.new(0.5, 0)
				})
			}),
			PlayerListGUI = createElement(GUI, { inset = true, zIndex = 5 }, {
				PlayerList = createElement(PlayerList, {
					compact = true,
					size = UDim.new(0, 200),
					position = UDim2.new(1, -4, 0, 0),
					anchorPoint = Vector2.new(1, 0)
				})
			}),
			VotekickGUI = createElement(GUI, { inset = true, zIndex = 10 }, {
				Votekick = createElement(Votekick, {
					size = UDim.new(1, -40),
					position = UDim2.new(0.5, 0, 0, 20),
					anchorPoint = Vector2.new(0.5, 0)
				})
			}),
			UserDataGUI = createElement(GUI, {
				zIndex = 5,
				inset = true,
				visible = v2:map(function(p2): boolean
					return p2 > 0.025
				end)
			}, {
				UserData = createElement(UserData, {
					transparency = p.useMemo(function()
						return Binding.mapLerp(v2, 1, 0)
					end, { v2 }),
					position = UDim2.new(0.5, 0, 0, 16),
					anchorPoint = Vector2.new(0.5, 0)
				})
			}),
			NavigationGUI = createElement(GUI, {
				zIndex = 5,
				visible = v3:map(function(p2): boolean
					return p2 > 0.025
				end)
			}, {
				Navigation = createElement(Navigation, {
					transparency = p.useMemo(function()
						return Binding.mapLerp(v3, 1, 0)
					end, { v3 }),
					position = p.useMemo(function()
						return v3:map(function(p2)
							return UDim2.new(0.5, 0, 1, Number.lerp(-72, -104, p2))
						end)
					end, { v3 }),
					anchorPoint = Vector2.new(0.5, 1)
				})
			}),
			ToolbarGUI = createElement(GUI, {
				inset = true,
				zIndex = 1,
				visible = v4:map(function(p2): boolean
					return p2 > 0.025
				end)
			}, {
				Toolbar = createElement(Toolbar, {
					transparency = p.useMemo(function()
						return Binding.mapLerp(v4, 1, 0)
					end, { v4 }),
					groups = p.useMemo(function()
						return { "history", "actions", "camera" }
					end, {}),
					position = p.useMemo(function()
						return v4:map(function(p2)
							return UDim2.new(0.5, 0, 0, 18 + Number.lerp(0, 12, p2))
						end)
					end, { v4 }),
					anchorPoint = Vector2.new(0.5, 0.5)
				})
			}),
			PanelsGUI = createElement(GUI, {
				zIndex = 2,
				visible = v5:map(function(p2): boolean
					return p2 > 0.025
				end)
			}, {
				Panels = createElement(Panels, {
					transparency = p.useMemo(function()
						return Binding.mapLerp(v5, 1, 0)
					end, { v5 }),
					position = p.useMemo(function()
						return v5:map(function(p2)
							return UDim2.new(0.5, 0, 1, -(Number.lerp(-16, 16, p2) + 64 + 4))
						end)
					end, { v5 }),
					anchorPoint = Vector2.new(0.5, 1)
				})
			}),
			ToolboxGUI = createElement(GUI, {
				zIndex = 3,
				visible = v6:map(function(p2): boolean
					return p2 > 0.025
				end)
			}, {
				Toolbox = createElement(Toolbox, {
					transparency = p.useMemo(function()
						return Binding.mapLerp(v6, 1, 0)
					end, { v6 }),
					position = p.useMemo(function()
						return v6:map(function(p2)
							return UDim2.new(0.5, 0, 1, -Number.lerp(-16, 16, p2))
						end)
					end, { v6 }),
					anchorPoint = Vector2.new(0.5, 1)
				})
			}),
			DialogManager = 0,
			Loading = 0,
			SaveFilesGUI = 0,
			SettingsGUI = 0,
			RulesGUI = 0,
			ProGUI = 0,
			VersionHistoryGUI = 0
		}
		local dialog

		if screen.name == "dialog" then
			dialog = screen
		end

		children.DialogManager = createElement(DialogManager, { dialog = dialog, onClose = onClose })

		children.Loading = createElement(Loading, {
			active = screen.name == "loading"
		})

		children.SaveFilesGUI = createElement(SlideGUI, {
			active = screen.name == "saveFiles",
			dontUnload = true,
			zIndex = 10,
			onClose = onClose
		}, {
			SaveFiles = createElement(SaveFiles, { paginated = true })
		})

		children.SettingsGUI = createElement(SlideGUI, {
			active = screen.name == "settings",
			zIndex = 10,
			onClose = onClose
		}, { Settings = createElement(Settings) })

		children.RulesGUI = createElement(SlideGUI, {
			active = screen.name == "rules",
			autoSize = true,
			zIndex = 10,
			onClose = onClose
		}, { Rules = createElement(Rules) })

		children.ProGUI = createElement(SlideGUI, {
			active = screen.name == "pro",
			autoSize = true,
			onClose = onClose
		}, {
			Pro = createElement(Pro, {
				active = screen.name == "pro",
				recipient = screen.options.recipient
			})
		})

		children.VersionHistoryGUI = createElement(SlideGUI, {
			active = screen.name == "versionHistory",
			size = UDim.new(0, 400),
			onClose = onClose
		}, { VersionHistory = createElement(VersionHistory) })
		v8 = createFragment(children)
	end

	v7[1] = v8
	v7.Claims = createElement(Claims)
	return createFragment(v7)
end

local v2 = hook(Phone, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return { drawing = p.camera.enabled }
end)(v2))