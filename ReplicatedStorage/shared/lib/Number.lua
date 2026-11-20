local Number = {}

function Number.lerp(p, p2, p3)
	return p + (p2 - p) * p3
end

function Number.map(p, p2, p3, p4, p5)
	return (p - p2) * (p5 - p4) / (p3 - p2) + p4
end

function Number.round(p, value)
	value = value or 1
	return math.round(p / value) * value
end

function Number.getAngleDelta(p, p2)
	local angleDelta = (p2 - p) % 6.283185307179586

	if angleDelta > 3.141592653589793 then
		angleDelta -= 6.283185307179586
	end

	return angleDelta
end

return Number