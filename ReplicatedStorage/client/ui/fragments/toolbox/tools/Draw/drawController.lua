local drawSlice = require(script.Parent.drawSlice)

local function drawController(object)
	return {
		handleActiveInput = function(p)
			object:dispatch(drawSlice.actions.createLine(p.id, p.position))
			object:flush()

			return {
				move = function(p2)
					object:dispatch(drawSlice.actions.addPointToLine(p.id, p2))
					object:flush()
				end,
				release = function()
					object:dispatch(drawSlice.thunks.finishLineAsync(p.id))
				end,
				cancel = function()
					object:dispatch(drawSlice.actions.deleteLine(p.id))
				end
			}
		end
	}
end

return drawController