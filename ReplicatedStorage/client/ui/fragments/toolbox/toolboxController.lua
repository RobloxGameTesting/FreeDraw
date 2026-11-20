local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local toolboxToolController = require(script.Parent.toolboxToolController)
local toolboxToolRendererController = require(script.Parent.toolboxToolRendererController)
local toolboxCursorController = require(script.Parent.toolboxCursorController)

local function toolboxController(p)
	local v = Maid.new({ toolboxToolController(p), toolboxToolRendererController(p), toolboxCursorController(p) })

	return function()
		v:clean()
	end
end

return toolboxController