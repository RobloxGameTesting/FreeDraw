local shapeSlice = require(script.Parent.shapeSlice)

local function shapeController(object)
	return {
		handleActiveInput = function(p)
			object:dispatch(shapeSlice.actions.createShape(p.id, p.position))
			object:flush()

			return {
				move = function(p2)
					object:dispatch(shapeSlice.actions.moveShape(p.id, p2))
					object:flush()
				end,
				release = function()
					object:dispatch(shapeSlice.thunks.finishShapeAsync(p.id))
				end,
				cancel = function()
					object:dispatch(shapeSlice.actions.deleteShape(p.id))
				end
			}
		end
	}
end

return shapeController