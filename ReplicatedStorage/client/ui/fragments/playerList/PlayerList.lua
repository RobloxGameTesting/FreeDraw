local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactFlipper = require(ReplicatedStorage.packages.RoactFlipper)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local CanvasContainer = require(ReplicatedStorage.client.ui.components.base.CanvasContainer)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local playerListSlice = require(script.Parent.playerListSlice)
local playersSlice = require(ReplicatedStorage.client.ui.fragments.players.playersSlice)
local votekickSlice = require(ReplicatedStorage.client.ui.fragments.votekick.votekickSlice)
local screensSlice = require(ReplicatedStorage.client.ui.fragments.screens.screensSlice)
local toolboxSlice = require(ReplicatedStorage.client.ui.fragments.toolbox.toolboxSlice)
local PlayerListPlayer = require(script.Parent.PlayerListPlayer)

local v = { frequency = 8, dampingRatio = 1 }
local udim = UDim.new(0, 8)

local createElement = Roact.createElement

local function PlayerList(props, p)
	local v2 = RoactFlipper.useSpring(p, props.open and 1 or 0, v)

	local sorted = Sift.List.sort(Sift.Dictionary.values(props.players), function(p2, p3): boolean
		return p2.displayName:lower() < p3.displayName:lower()
	end)

	local children = {}

	for k, v3 in sorted do
		local v4 = sorted[k - 1]
		local v5 = sorted[k + 1]

		local visible = not props.compact or (not props.selectedPlayer or v3.id == props.selectedPlayer)

		children[v3.name] = createElement(PlayerListPlayer, Sift.Dictionary.join(v3, {
			active = v3.id == props.selectedPlayer,
			topRounded = not v4 or v4.id == props.selectedPlayer,
			bottomRounded = not v5 or v5.id == props.selectedPlayer,
			layoutOrder = k,
			visible = visible,
			compact = props.compact,
			onClick = props.onSelect,
			onVotekickClick = props.onVotekickClick,
			onVisibilityClick = props.onVisibilityClick,
			onReportClick = props.onReportClick,
			onGiftProClick = props.onGiftProClick
		}))
	end

	return createElement(CanvasContainer, {
		transparency = p.useMemo(function()
			return Binding.mapLerp(v2, 1, 0)
		end, { v2 }),
		size = UDim2.new(udim + props.size + udim, 0),
		automaticSize = Enum.AutomaticSize.Y,
		position = props.position,
		anchorPoint = props.anchorPoint,
		visible = v2:map(function(p2): boolean
			return p2 > 0.025
		end)
	}, Sift.Dictionary.join(children, {
		Layout = createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 8) + udim,
			PaddingRight = udim,
			PaddingTop = udim,
			PaddingBottom = udim
		})
	}))
end

local v2 = hook(PlayerList, { componentType = "PureComponent" })

return (RoactRodux.connect(function(data)
	local v3 = { players = data.players, selectedPlayer = data.playerList.selectedPlayer, open = 0 }
	local open = data.playerList.open

	if open then
		local visible = data.votekick and data.votekick.visible
		open = not visible
	end

	v3.open = open
	return v3
end, function(callback)
	return {
		onSelect = function(p)
			callback(playerListSlice.actions.selectPlayer(p))
		end,
		onVotekickClick = function(p)
			callback(votekickSlice.thunks.votekickDialog(p))
		end,
		onVisibilityClick = function(p)
			callback(function(object)
				local player = object:getState().players[p]
				object:dispatch(playersSlice.actions.setPlayerHidden(p, not player.hidden))
			end)
		end,
		onReportClick = function(p)
			callback(toolboxSlice.actions.setTool(nil))
			callback(screensSlice.actions.pushScreen("report", {
				target = Players:GetPlayerByUserId(p)
			}))
		end,
		onGiftProClick = function(p)
			callback(screensSlice.actions.pushScreen("pro", {
				recipient = Players:GetPlayerByUserId(p)
			}))
		end
	}
end)(v2))