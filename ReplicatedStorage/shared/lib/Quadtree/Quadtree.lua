local QuadtreeGrid = require(script.Parent.QuadtreeGrid)
local QuadtreeElement = require(script.Parent.QuadtreeElement)

local move = require(script.Parent.move)

local v = Vector2.one * 512

local Quadtree = {}
Quadtree.__index = Quadtree

function Quadtree.new()
	local self = setmetatable({ elements = {} }, Quadtree)

	self.grid = QuadtreeGrid.new(self, v)

	return self
end

function Quadtree:query(rect: Rect)
	local data = {}

	for _, v2 in self.grid:getNodes(rect) do
		move(v2:query(rect), data)
	end

	for i = 1, #data do
		data[i] = data[i].data
	end

	return data
end

function Quadtree:insert(p, rect: Rect)
	local v2 = QuadtreeElement.new(p, rect)
	local nodes = self.grid:ensureNodes(rect)

	for _, node in nodes do
		node:insert(v2)
	end

	self.elements[p] = v2
end

function Quadtree.remove(p, p2)
	local element = p.elements[p2]
	element:destroy()
	p.elements[p2] = nil

	local nodes = p.grid:getNodes(element.rect)

	for _, node in nodes do
		if node.counter == 0 then
			p.grid:removeNode(node)
		end
	end
end

return Quadtree