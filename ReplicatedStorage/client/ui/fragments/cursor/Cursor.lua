local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Color = require(ReplicatedStorage.packages.Color)

local hook = require(ReplicatedStorage.shared.util.hook)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local CursorType = require(ReplicatedStorage.shared.enum.CursorType)
local CursorTracker = require(ReplicatedStorage.client.ui.fragments.cursor.CursorTracker)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local PointerType = require(ReplicatedStorage.shared.enum.PointerType)
local colors = require(ReplicatedStorage.client.ui.assets.colors)

local function getMousePosition()
	local mouseLocation = UserInputService:GetMouseLocation()
	return Vector2.new(mouseLocation.X, mouseLocation.Y)
end

local v = {
	[CursorType.Default] = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png",
	[CursorType.Pointer] = "rbxasset://textures/Cursors/KeyboardMouse/ArrowCursor.png",
	[CursorType.Text] = "rbxasset://textures/Cursors/KeyboardMouse/IBeamCursor.png"
}

local createElement = Roact.createElement
local createFragment = Roact.createFragment

local function Cursor(p, p2)
	local v2, v3 = p2.useBinding(getMousePosition())
	local v4, v5 = p2.useBinding(CursorTracker.getCursor())

	p2.useEffect(function()
		local v6 = Maid.new({
			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					v3(getMousePosition())
				end
			end),
			CursorTracker.onCursorChanged:connect(function(p3)
				v5(p3)
			end),
			RunService.Heartbeat:Connect(function()
				UserInputService.MouseIconEnabled = v4:getValue() == CursorType.Roblox
			end)
		})

		return function()
			v6:clean()
		end
	end, {})

	if not p.enabled then
		return
	end

	local v6 = {
		circular = true,
		color = p.color,
		borderColor = 0,
		borderThickness = 2,
		size = 0,
		position = 0,
		anchorPoint = 0,
		visible = 0
	}
	local borderColor

	if Color.GetPerceivedBrightness(p.color) < 0.25 then
		borderColor = colors.white
	else
		borderColor = colors.black
	end

	v6.borderColor = borderColor

	v6.size = UDim2.fromOffset(6, 6)
	v6.position = v2:map(function(p3)
		return UDim2.fromOffset(p3.X, p3.Y)
	end)

	v6.anchorPoint = Vector2.new(0.5, 0.5)

	v6.visible = v4:map(function(p3): boolean
		return p3 == CursorType.Draw and p3 ~= CursorType.Roblox
	end)
	return createFragment({
		DrawCursor = createElement(Box, v6),
		OtherCursor = createElement(Image, {
			image = v4:map(function(p3)
				return v[p3]
			end),
			size = UDim2.fromOffset(64, 64),
			position = v2:map(function(p3)
				return UDim2.fromOffset(p3.X, p3.Y)
			end),
			anchorPoint = Vector2.new(0.5, 0.5),
			visible = v4:map(function(p3): boolean
				return p3 ~= CursorType.Draw and p3 ~= CursorType.Roblox
			end)
		})
	})
end

local v2 = hook(Cursor, { componentType = "PureComponent" })

return (RoactRodux.connect(function(p)
	return {
		color = p.options.color.primary,
		enabled = p.platform.pointer == PointerType.Mouse
	}
end)(v2))