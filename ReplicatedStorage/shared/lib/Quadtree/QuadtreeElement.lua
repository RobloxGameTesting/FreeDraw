local QuadtreeElement = {}
QuadtreeElement.__index = QuadtreeElement

function QuadtreeElement.new(p, rect: Rect)
	return (setmetatable({ data = p, rect = rect, nodes = {} }, QuadtreeElement))
end

function QuadtreeElement.track(p, p2)
	table.insert(p.nodes, p2)
end

function QuadtreeElement.untrack(p, p2)
	table.remove(p.nodes, table.find(p.nodes, p2))
end

function QuadtreeElement.destroy(p)
	for _ = 1, #p.nodes do
		p.nodes[1]:remove(p)
	end
end

return QuadtreeElement