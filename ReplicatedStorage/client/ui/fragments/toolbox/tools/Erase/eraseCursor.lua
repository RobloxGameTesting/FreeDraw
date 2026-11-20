local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cursor = require(ReplicatedStorage.shared.render.Cursor)
local CursorShape = require(ReplicatedStorage.shared.enum.CursorShape)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local function eraseCursor()
	local v = Cursor.new(CursorShape.Circle)

	return {
		render = function(p, p2)
			v:setPosition(p)
			v:setSize(p2.toolbox.tools[ToolType.Erase].options.radius * 2)
		end,
		destroy = function()
			v:destroy()
		end
	}
end

return eraseCursor