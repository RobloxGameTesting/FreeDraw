local ReplicatedStorage = game:GetService("ReplicatedStorage")

local make = require(ReplicatedStorage.shared.util.make)
local Number = require(ReplicatedStorage.shared.lib.Number)
local CollisionGroup = require(ReplicatedStorage.shared.enum.CollisionGroup)

local v = make("Part", {
	Anchored = true,
	CanCollide = false,
	CanTouch = false,
	CFrame = CFrame.new(0, -10000, 0),
	TopSurface = Enum.SurfaceType.SmoothNoOutlines,
	BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
	LeftSurface = Enum.SurfaceType.SmoothNoOutlines,
	RightSurface = Enum.SurfaceType.SmoothNoOutlines,
	FrontSurface = Enum.SurfaceType.SmoothNoOutlines,
	BackSurface = Enum.SurfaceType.SmoothNoOutlines,
	CollisionGroup = CollisionGroup.Render.value
})

local function getCornerOffset(points, p)
	local v2 = points[p - 1]
	local v3 = points[p]
	local v4 = points[p + 1]

	if not (v2 and v4) then
		return 0
	end

	local v5 = v3 - v2
	local v6 = v4 - v3

	local v7 = math.atan2(v5.X, v5.Y)
	local v8 = math.atan2(v6.X, v6.Y)

	local v9 = math.abs((Number.getAngleDelta(v7, v8)))

	if v9 < 1.5707963267948966 then
		return (math.tan(v9 / 2))
	end

	return (math.tan((3.141592653589793 - v9) / 2))
end

local function fuzzyEquals(point, point2, p) -- 2 equivalent calls inferred from this helper
	if point and point2 then
		return Vector3.new(point.X, point.Y):FuzzyEq(Vector3.new(point2.X, point2.Y), p)
	end

	return false
end

local Line = {}
Line.__index = Line
Line.getCornerOffset = getCornerOffset

function Line.new(options3, options, options2)
	local line = Instance.new("Model")
	line.Name = "Line"

	return (setmetatable({
		container = line,
		options = options3,
		points = options or {},
		parts = options2 or {},
		offset = 0
	}, Line))
end

function Line.takeOwnershipOfParts(p)
	for _, part in p.parts do
		part.Parent = p.container
	end
end

function Line:setOffset(offset)
	self.offset = offset

	for _, part in self.parts do
		part.CFrame += Vector3.new(0, offset - part.CFrame.Y, 0)
	end
end

function Line.setParent(p, parent)
	p.container.Parent = parent
end

function Line:render(points)
	local count = #self.parts
	local v2 = #points - 1

	local points2 = self.points
	self.points = points

	if count < v2 then
		for i = count + 1, v2 do
			local clone = v:Clone()
			clone.Color = self.options.color
			clone.Transparency = self.options.transparency
			self.parts[i] = clone
		end
	elseif v2 < count then
		for i = v2 + 1, count do
			self.parts[i]:Destroy()
			self.parts[i] = nil
		end
	end

	for i = 1, v2 do
		local point = points[i]
		local point2 = points[i + 1]
		local point3 = points2[i]
		local point4 = points2[i + 1]

		if fuzzyEquals(point, point3) and fuzzyEquals(point2, point4) then -- inferred equivalent call
			continue
		end

		if i > 1 then
			self:renderPartAtIndex(i - 1)
		end

		self:renderPartAtIndex(i)
	end

	if count < v2 then
		for i = count + 1, v2 do
			self.parts[i].Parent = self.container
		end
	end
end

function Line:renderPartAtIndex(p)
	local points = self.points
	local thickness = self.options.thickness

	local part = self.parts[p]

	local point = points[p]
	local point2 = points[p + 1]

	local v2 = getCornerOffset(points, p) * thickness / 2
	local v3 = getCornerOffset(points, p + 1) * thickness / 2

	local unit = (point2 - point).Unit
	local v4 = point - unit * v2
	local v5 = point2 + unit * v3 - v4
	local magnitude = v5.Magnitude

	local v6 = v4 + v5 / 2
	local v7 = math.atan2(v5.X, v5.Y)

	part.CFrame = CFrame.new(v6.X, self.offset, v6.Y) * CFrame.Angles(0, v7, 0)
	part.Size = Vector3.new(thickness, 0, magnitude)
end

function Line:destroy()
	self.container:destroy()
end

return Line