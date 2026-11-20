local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local make = require(ReplicatedStorage.shared.util.make)

local CursorShape = require(ReplicatedStorage.shared.enum.CursorShape)

local v = {
	[CursorShape.Square] = {
		Vector2.new(0, 0),
		Vector2.new(1, 0),
		Vector2.new(1, 1),
		Vector2.new(0, 1),
		Vector2.new(0, 0)
	}
}

local Circle = CursorShape.Circle
local v2 = {}

for i = 0, 45 do
	local v3 = i / 45 * 3.141592653589793 * 2

	table.insert(v2, (Vector2.new(math.sin(v3), (math.cos(v3))) + Vector2.new(1, 1)) / 2)
end

v[Circle] = v2

local Cursor = {}
Cursor.__index = Cursor

function Cursor.new(shape)
	local self = setmetatable({ shape = shape, _lines = {} }, Cursor)

	self._part = make("Part", {
		Size = Vector3.new(1, 1, 1),
		Transparency = 1,
		Anchored = true,
		Locked = true,
		CanCollide = false,
		Name = "Cursor",
		Parent = Workspace
	})

	for _ = 1, #v[shape] - 1 do
		table.insert(self._lines, make("LineHandleAdornment", {
			Color3 = Color3.new(0, 0, 0),
			Thickness = 2,
			ZIndex = 0,
			AlwaysOnTop = true,
			Adornee = self._part,
			Name = "Segment",
			Parent = self._part
		}))
	end

	self:setSize(1)

	return self
end

function Cursor:setPosition(p)
	self._part.CFrame = CFrame.new(p.X, 0, p.Y)
end

function Cursor:setSize(p)
	local v3 = v[self.shape]

	for i = 1, #self._lines do
		local v4 = (v3[i] - Vector2.new(0.5, 0.5)) * p
		local v5 = (v3[i + 1] - Vector2.new(0.5, 0.5)) * p - v4
		local v6 = math.atan2(v5.X, v5.Y) + 3.141592653589793

		local line = self._lines[i]
		line.Length = v5.Magnitude
		line.CFrame = CFrame.new(v4.X, 0, v4.Y) * CFrame.Angles(0, v6, 0)
	end
end

function Cursor:destroy()
	self._part:Destroy()
end

return Cursor