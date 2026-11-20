local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local getLayerObject = require(ReplicatedStorage.client.ui.fragments.layers.getLayerObject)
local remotes = require(ReplicatedStorage.shared.remotes)
local Number = require(ReplicatedStorage.shared.lib.Number)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local eraseParts = remotes.Client:Get("eraseParts")

local function getPrecomputedPartData(layerObject)
	local precomputedPartData = {}

	for _, child in layerObject:GetChildren() do
		for _, child2 in child:GetChildren() do
			local vector2 = Vector2.new(child2.Position.X, child2.Position.Z)
			local x = child2.Size.X
			local z = child2.Size.Z

			local lookVector = child2.CFrame.LookVector
			local vector2_2 = Vector2.new(lookVector.X, lookVector.Z)
			local delta = vector2_2 * z

			table.insert(precomputedPartData, {
				part = child2,
				center = vector2,
				direction = vector2_2,
				thickness = x,
				length = z,
				delta = delta,
				startPoint = vector2 - delta / 2,
				endPoint = vector2 + delta / 2,
				totalRadius = math.sqrt(z * z + x * x) / 2
			})
		end
	end

	return precomputedPartData
end

local function filterCollidingParts(precomputedPartData, p, radius) -- 1 equivalent call inferred from this helper
	return Sift.List.filter(precomputedPartData, function(data): boolean
		if (data.center - p).Magnitude <= data.totalRadius + radius then
			local v = p - data.startPoint

			local v2 = data.delta:Dot(v) / data.length

			if (p - (data.startPoint + data.direction * math.clamp(v2, 0, data.length))).Magnitude <= data.thickness / 2 + radius then
				return true
			end
		end

		return false
	end)
end

local function eraseController(object)
	return {
		handleActiveInput = function(p)
			local selectedLayer = object:getState().layers.selectedLayer

			local parts = {}
			local transparenciesByPart = {}
			local precomputedPartData = getPrecomputedPartData(getLayerObject(selectedLayer))

			local function move(position)
				local v = filterCollidingParts( -- inferred equivalent call
					precomputedPartData,
					position,
					object:getState().toolbox.tools[ToolType.Erase].options.radius
				)

				for _, v2 in v do
					local part = v2.part

					if table.find(parts, part) then
						continue
					end

					transparenciesByPart[part] = part.Transparency
					part.Transparency = Number.lerp(part.Transparency, 1, 0.5)
					table.insert(parts, part)
				end
			end

			move(p.position)

			local function release()
				eraseParts:CallServerAsync(selectedLayer, parts)
			end

			local function cancel()
				for _, v in parts do
					v.Transparency = transparenciesByPart[v]
				end
			end

			return { move = move, release = release, cacnel = cancel }
		end
	}
end

return eraseController