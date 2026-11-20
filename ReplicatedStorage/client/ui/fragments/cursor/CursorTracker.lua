local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local Signal = require(ReplicatedStorage.shared.class.Signal)

local v = {}
local onCursorChanged = Signal.new()

local function getCursor() -- 2 equivalent calls inferred from this helper
	local cursor = CursorType.Draw

	for _, v2 in v do
		if v2.value > cursor.value then
			cursor = v2
		end
	end

	return cursor
end

local function setCursor(p, p2)
	v = Sift.Dictionary.set(v, p2, p)
	onCursorChanged:fire(getCursor()) -- inferred equivalent call
end

local function releaseCursor(p)
	v = Sift.Dictionary.removeKey(v, p)
	onCursorChanged:fire(getCursor()) -- inferred equivalent call
end

return {
	getCursor = getCursor,
	onCursorChanged = onCursorChanged,
	setCursor = setCursor,
	releaseCursor = releaseCursor
}