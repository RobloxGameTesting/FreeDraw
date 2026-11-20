local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = require(ReplicatedStorage.shared.remotes)
local lineSlice = require(script.Parent.lineSlice)
local optionsSlice = require(ReplicatedStorage.client.ui.fragments.options.optionsSlice)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local createLine = remotes.Client:Get("createLine")

local function lineController(object)
	return {
		handleActiveInput = function(p)
			object:dispatch(lineSlice.actions.createLine(p.id, p.position))
			object:flush()

			return {
				move = function(p2)
					object:dispatch(lineSlice.actions.moveLine(p.id, p2))
					object:flush()
				end,
				release = function()
					local state = object:getState()
					local tool = state.toolbox.tools[ToolType.Line]

					local selectedLayer = state.layers.selectedLayer
					local line = tool.lines[p.id]
					createLine:CallServerAsync(selectedLayer, optionsSlice.selectors.selectOptions(state), line):finally(function()
						object:dispatch(lineSlice.actions.deleteLine(p.id))
						object:flush()
					end)
				end,
				cancel = function()
					object:dispatch(lineSlice.actions.deleteLine(p.id))
				end
			}
		end
	}
end

return lineController