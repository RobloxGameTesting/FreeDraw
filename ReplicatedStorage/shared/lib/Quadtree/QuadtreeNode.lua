local move = require(script.Parent.move)

local vector2 = Vector2.new(0, 0)
local vector2_2 = Vector2.new(1, 0)
local vector2_3 = Vector2.new(0, 1)
local vector2_4 = Vector2.new(1, 1)

local function rectPartition(rect: Rect)
	local v = (rect.Max - rect.Min) / 2

	local v2 = rect.Min + v * vector2
	local v3 = rect.Min + v * vector2_2
	local v4 = rect.Min + v * vector2_3
	local v5 = rect.Min + v * vector2_4

	return Rect.new(v2, v2 + v), Rect.new(v3, v3 + v), Rect.new(v4, v4 + v), Rect.new(v5, v5 + v)
end

local function rectIntersects(rect: Rect, rect2: Rect): boolean -- 4 equivalent calls inferred from this helper
	return not (rect2.Min.X > rect.Max.X or rect2.Max.X < rect.Min.X or rect2.Min.Y > rect.Max.Y or rect2.Max.Y < rect.Min.Y)
end

local function rectContains(rect: Rect, rect2: Rect): boolean -- 1 equivalent call inferred from this helper
	return rect.Min.X <= rect2.Min.X
		and rect.Min.Y <= rect2.Min.Y
		and rect2.Max.X <= rect.Max.X
		and rect2.Max.Y <= rect.Max.Y
end

local QuadtreeNode = {}
QuadtreeNode.__index = QuadtreeNode

function QuadtreeNode.new(rect: Rect, tree, parent)
	return (setmetatable({
		rect = rect,
		tree = tree,
		parent = parent,
		elements = nil,
		nodes = nil,
		depth = not parent and 0 or parent.depth + 1,
		counter = 0
	}, QuadtreeNode))
end

function QuadtreeNode:all()
	if self.elements then
		return self.elements
	end

	if not self.nodes then
		return {}
	end

	local v = {}

	for _, node in self.nodes do
		move(node:all(), v)
	end

	return v
end

function QuadtreeNode:query(rect: Rect)
	if rectContains(rect, self.rect) then -- inferred equivalent call
		return self:all()
	end

	local elements = {}

	if self.elements then
		for _, element in self.elements do
			if rectIntersects(rect, element.rect) then -- inferred equivalent call
				table.insert(elements, element)
			end
		end
	elseif self.nodes then
		for _, node in self.nodes do
			if rectIntersects(rect, node.rect) then -- inferred equivalent call
				move(node:query(rect), elements)
			end
		end
	end

	return elements
end

function QuadtreeNode:count(p: number)
	self.counter += p

	if self.parent then
		self.parent:count(p)
	end

	if self.counter < 4 then
		self:flatten()
	end
end

function QuadtreeNode:split()
	if self.depth < 5 then
		if not self.nodes then
			local v, v2, v3, v4 = rectPartition(self.rect)

			self.nodes = {
				QuadtreeNode.new(v, self.tree, self),
				QuadtreeNode.new(v2, self.tree, self),
				QuadtreeNode.new(v3, self.tree, self),
				QuadtreeNode.new(v4, self.tree, self)
			}
		end

		if self.elements then
			for _, node in self.nodes do
				for _, element in self.elements do
					if rectIntersects(element.rect, node.rect) then -- inferred equivalent call
						node:insert(element)
					end
				end
			end

			for _, element in self.elements do
				element:untrack(self)
			end

			self.elements = nil
		end
	end
end

function QuadtreeNode:flatten()
	if self.nodes then
		for _, node in self.nodes do
			if node.nodes then
				node:flatten()
			end

			if node.elements then
				move(node.elements, self.elements)
			end
		end

		self.nodes = nil
	end
end

function QuadtreeNode:insert(object)
	if self.nodes then
		for _, node in self.nodes do
			if rectIntersects(object.rect, node.rect) then -- inferred equivalent call
				node:insert(object)
			end
		end
	else
		if not self.elements then
			self.elements = {}
		end

		table.insert(self.elements, object)
		object:track(self)
		self:count(1)

		if self.counter > 9 then
			self:split()
		end
	end
end

function QuadtreeNode:remove(object)
	table.remove(self.elements, table.find(self.elements, object))
	object:untrack(self)
	self:count(-1)
end

return QuadtreeNode