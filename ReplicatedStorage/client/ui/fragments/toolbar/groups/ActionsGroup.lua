local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local ButtonType = require(ReplicatedStorage.shared.enum.ButtonType)
local Localization = require(ReplicatedStorage.shared.lib.Localization)
local ToolbarGroup = require(script.Parent.Parent.ToolbarGroup)
local toolbarSlice = require(script.Parent.Parent.toolbarSlice)

local createElement = Roact.createElement

local function ActionsGroup(p)
	return createElement(ToolbarGroup, {
		buttons = {
			{
				id = "clearAll",
				name = Localization.String.new("toolbar.tooltip.clearAll"),
				type = ButtonType.Icon,
				icon = "trash",
				onClick = p.onNavigateClearAll
			}
		},
		layoutOrder = p.layoutOrder
	})
end

local v = hook(ActionsGroup, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onNavigateClearAll = function()
			callback(toolbarSlice.thunks.clearAllDialog())
		end
	}
end)(v))