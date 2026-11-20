local QuadtreeNode = require(script.Parent.QuadtreeNode)

local QuadtreeGrid = {}
QuadtreeGrid.__index = QuadtreeGrid

function QuadtreeGrid.new(tree, size: Vector2)
	return (setmetatable({ tree = tree, size = size, data = {}, indexes = {} }, QuadtreeGrid))
end

function QuadtreeGrid:getIndexRange(rect: Rect)
	local v = rect.Min / self.size
	local v2 = rect.Max / self.size

	return Vector2.new(math.floor(v.X), (math.floor(v.Y))), (Vector2.new(math.floor(v2.X), (math.floor(v2.Y))))
end

function QuadtreeGrid:getNodes(rect: Rect)
	local indexRange, v = self:getIndexRange(rect)

	local nodes = {}

	for i = indexRange.X, v.X do
		local v2 = self.data[i]

		if not v2 then
			continue
		end

		for j = indexRange.Y, v.Y do
			local v3 = v2[j]

			if v3 then
				table.insert(nodes, v3)
			end
		end
	end

	return nodes
end

function QuadtreeGrid:ensureNodes(rect: Rect)
	local indexRange, v = self:getIndexRange(rect)

	local nodes = {}

	for i = indexRange.X, v.X do
		local v2 = self.data[i]

		if not v2 then
			v2 = {}
			self.data[i] = v2
		end

		for j = indexRange.Y, v.Y do
			local v3 = v2[j]

			if not v3 then
				local vector2 = Vector2.new(i, j)

				local v4 = vector2 * self.size
				local v5 = v4 + self.size
				v3 = QuadtreeNode.new(Rect.new(v4, v5), self.tree, nil)

				v2[j] = v3
				self.indexes[v3] = vector2
			end

			table.insert(nodes, v3)
		end
	end

	return nodes
end

function QuadtreeGrid.removeNode(p, p2)
	local index = p.indexes[p2]

	p.data[index.X][index.Y] = nil

	if not next(p.data[index.X]) then
		p.data[index.X] = nil
	end

	p.indexes[p2] = nil
end

return QuadtreeGrid