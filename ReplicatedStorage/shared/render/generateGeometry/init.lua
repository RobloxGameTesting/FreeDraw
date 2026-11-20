local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vector = require(ReplicatedStorage.shared.lib.Vector)
local Line = require(ReplicatedStorage.shared.render.Line)
local GeometryType = require(ReplicatedStorage.shared.enum.GeometryType)

local v = {}
local Circle = GeometryType.Circle
local circle = require(script.circle)
v[Circle] = circle
local Rectangle = GeometryType.Rectangle
local rectangle = require(script.rectangle)
v[Rectangle] = rectangle
local Polygon = GeometryType.Polygon
local polygon = require(script.polygon)
v[Polygon] = polygon
local Star = GeometryType.Star
local star = require(script.star)
v[Star] = star

local function generateGeometry(data, p)
	local rotated = Vector.rotate(data.endPoint - data.startPoint, -data.rotation)
	local geometry = v[data.options.geometryType](rotated, data.options)

	if p then
		local v2 = Line.getCornerOffset({ geometry[#geometry - 1], geometry[1], geometry[2] }, 2) * p.thickness / 2
		geometry[1] -= (geometry[2] - geometry[1]).Unit * v2
		local count = #geometry
		geometry[count] += (geometry[#geometry] - geometry[#geometry - 1]).Unit * v2
	end

	for k, v2 in geometry do
		geometry[k] = data.startPoint + Vector.rotate(v2, data.rotation)
	end

	return geometry
end

return generateGeometry