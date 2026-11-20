local function castPolygonToAxis(items, unit: Vector2)
	local minValue = 1e999
	local maxValue = -1e999

	for _, item in items do
		local dot = item:Dot(unit)
		minValue = math.min(minValue, dot)
		maxValue = math.max(maxValue, dot)
	end

	return minValue, maxValue
end

local function castCircleToAxis(vector: Vector2, p: number, unit: Vector2) -- 2 equivalent calls inferred from this helper
	local dot = vector:Dot(unit)
	return dot - p, dot + p
end

local function isPolygonWithinPolygon(list, p): boolean
	for i = 1, #list do
		local item = list[i]
		local unit = ((list[i + 1] or list[1]) - item).Unit
		local v, v2 = castPolygonToAxis(list, unit)
		local v3, v4 = castPolygonToAxis(p, unit)

		if v - v4 > 0 or v3 - v2 > 0 then
			return false
		end
	end

	return true
end

local function isPointWithinBounds(p, p2, p3): boolean -- 4 equivalent calls inferred from this helper
	return p.X >= p2.X and p.Y >= p2.Y and p.X <= p3.X and p.Y <= p3.Y
end

local Collision = {}
Collision.isPolygonWithinPolygon = isPolygonWithinPolygon

function Collision.isCircleWithinPolygon(vector: Vector2, p: number, list): boolean
	local v = 1e999
	local v2 = nil

	for _, item in list do
		local magnitude = (item - vector).Magnitude

		if not (magnitude < v) then
			continue
		end

		v2 = item
		v = magnitude
	end

	for i = 1, #list do
		local item = list[i]
		local unit = ((list[i + 1] or list[1]) - item).Unit
		local v3, v4 = castCircleToAxis(vector, p, unit) -- inferred equivalent call
		local v5, v6 = castPolygonToAxis(list, unit)

		if v3 - v6 > 0 or v5 - v4 > 0 then
			return false
		end
	end

	local unit = (vector - v2).Unit
	local v3, v4 = castCircleToAxis(vector, p, unit) -- inferred equivalent call
	local v5, v6 = castPolygonToAxis(list, unit)

	return not (v3 - v6 > 0 or v5 - v4 > 0)
end

function Collision.isPointWithinCircle(vector2: Vector2, vector2_2: Vector2, p: number): boolean
	return (vector2_2 - vector2).Magnitude <= p
end

function Collision.isCircleWithinCircle(vector2: Vector2, p: number, vector2_2: Vector2, p2: number): boolean
	return (vector2_2 - vector2).Magnitude <= p + p2
end

Collision.isPointWithinBounds = isPointWithinBounds

function Collision.isLineWithinBounds(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2, vector2_4: Vector2): boolean
	if isPointWithinBounds(vector2, vector2_3, vector2_4) then -- inferred equivalent call
		return true
	end

	local v = vector2_2 - vector2

	local v2 = -v.X
	local x = v.X
	local v3 = -v.Y
	local y = v.Y

	local v4 = vector2.X - vector2_3.X
	local v5 = vector2_4.X - vector2.X
	local v6 = vector2.Y - vector2_3.Y
	local v7 = vector2_4.Y - vector2.Y

	if v2 == 0 and v4 < 0 or x == 0 and v5 < 0 or v3 == 0 and v6 < 0 or y == 0 and v7 < 0 then
		return false
	end

	local maxValue = -1e999
	local minValue = 1e999

	if v2 < 0 then
		maxValue = math.max(maxValue, v4 / v2)
	elseif v2 > 0 then
		minValue = math.min(minValue, v4 / v2)
	end

	if x < 0 then
		maxValue = math.max(maxValue, v5 / x)
	elseif x > 0 then
		minValue = math.min(minValue, v5 / x)
	end

	if v3 < 0 then
		maxValue = math.max(maxValue, v6 / v3)
	elseif v3 > 0 then
		minValue = math.min(minValue, v6 / v3)
	end

	if y < 0 then
		maxValue = math.max(maxValue, v7 / y)
	elseif y > 0 then
		minValue = math.min(minValue, v7 / y)
	end

	return not (minValue < maxValue or maxValue > 1 or maxValue < 0)
end

function Collision.isBoxWithinBounds(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2, vector2_4: Vector2): boolean
	return vector2.X - vector2_4.X > 0
		or vector2_3.X - vector2_2.X > 0 and vector2.Y - vector2_4.Y > 0
		or vector2_3.Y - vector2_2.Y > 0
end

function Collision.isCircleWithinBounds(vector2: Vector2, p: number, vector2_2: Vector2, vector2_3: Vector2): boolean
	if isPointWithinBounds(vector2, vector2_2, vector2_3) then -- inferred equivalent call
		return true
	end

	local vector2_4 = Vector2.new(p, p)

	if not isPointWithinBounds(vector2, vector2_2 - vector2_4, vector2_3 + vector2_4) then -- inferred equivalent call
		return false
	end

	if
		vector2.X >= vector2_2.X and vector2.X <= vector2_3.X
		or vector2.Y >= vector2_2.Y and vector2.Y <= vector2_3.Y
	then
		return true
	end

	return (vector2 - Vector2.new(
		math.clamp(vector2.X, vector2_2.X, vector2_3.X),
		(math.clamp(vector2.Y, vector2_2.Y, vector2_3.Y))
	)).Magnitude <= p
end

function Collision.isPolygonWithinBounds(p, vector2: Vector2, vector2_2: Vector2)
	return isPolygonWithinPolygon(p, {
		vector2,
		Vector2.new(vector2_2.X, vector2.Y),
		vector2_2,
		Vector2.new(vector2.X, vector2_2.Y)
	})
end

function Collision.isPointWithinObject(p, p2)
	local absolutePosition = p2.AbsolutePosition
	return isPointWithinBounds(p, absolutePosition, absolutePosition + p2.AbsoluteSize) -- inferred equivalent call
end

return Collision