local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local images = require(ReplicatedStorage.client.ui.assets.images)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local createElement = Roact.createElement

local function studs(p) -- 7 equivalent calls inferred from this helper
	return p * 100
end

local function Claim(props, p)
	local color = if props.error then colors.red[700] else colors.brand
	local transparency = props.temporary and 0.5 or 0.25

	local v = p.useMemo(Roact.createRef, {})
	p.useEffect(function()
		v.current:SetAttribute("owner", props.player.UserId)
	end, { props.player })
	p.useEffect(function()
		v.current:SetAttribute("temporary", props.temporary)
	end, { props.temporary })

	local v2 = {
		CFrame = CFrame.new(props.position.X, -0.05, props.position.Y) * CFrame.fromEulerAnglesXYZ(0, props.rotation, 0) * CFrame.fromEulerAnglesXYZ(0, -1.5707963267948966, 0),
		Size = Vector3.new(props.size.Y, 0.1, props.size.X),
		Anchored = true,
		CanCollide = false,
		CanTouch = false,
		Transparency = 1,
		[Roact.Ref] = v
	}

	local v3 = {
		Face = Enum.NormalId.Top,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = 100,
		AlwaysOnTop = true
	}

	local v4 = { size = UDim2.fromScale(1, 1) }
	local text

	if props.temporary then
		text = createElement(Text, {
			text = ("<b>%.2f</b> × <b>%.2f</b>"):format(props.size.X, props.size.Y),
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = studs(0.4), -- inferred equivalent call
			color = color,
			transparency = transparency,
			layoutOrder = 2
		})
	end

	local err

	if props.error then
		err = createElement(Text, {
			text = props.error,
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = studs(0.4), -- inferred equivalent call
			color = color,
			transparency = transparency,
			layoutOrder = 1
		})
	end

	return createElement("Part", v2, {
		GUI = createElement("SurfaceGui", v3, {
			Info = createElement(Container, v4, {
				Text = text,
				Error = err,
				Layout = createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, studs(0.1)) -- inferred equivalent call
				}),
				Padding = createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 15 + studs(0.2)), -- inferred equivalent call
					PaddingRight = UDim.new(0, 15 + studs(0.2)), -- inferred equivalent call
					PaddingTop = UDim.new(0, 15 + studs(0.2)), -- inferred equivalent call
					PaddingBottom = UDim.new(0, 15 + studs(0.2)) -- inferred equivalent call
				})
			}),
			Border = createElement(Container, { size = UDim2.fromScale(1, 1) }, {
				Top = createElement(Image, {
					image = images.claim.line.horizontal,
					color = color,
					transparency = transparency,
					scaleType = Enum.ScaleType.Tile,
					tileSize = UDim2.new(0, 65, 1, 0),
					size = UDim2.new(1, -15, 0, 15),
					position = UDim2.fromScale(0, 0),
					anchorPoint = Vector2.new(0, 0)
				}),
				Bottom = createElement(Image, {
					image = images.claim.line.horizontal,
					color = color,
					transparency = transparency,
					scaleType = Enum.ScaleType.Tile,
					tileSize = UDim2.new(0, 65, 1, 0),
					size = UDim2.new(1, -15, 0, 15),
					position = UDim2.fromScale(1, 1),
					anchorPoint = Vector2.new(1, 1)
				}),
				Left = createElement(Image, {
					image = images.claim.line.vertical,
					color = color,
					transparency = transparency,
					scaleType = Enum.ScaleType.Tile,
					tileSize = UDim2.new(1, 0, 0, 65),
					size = UDim2.new(0, 15, 1, -15),
					position = UDim2.fromScale(0, 1),
					anchorPoint = Vector2.new(0, 1)
				}),
				Right = createElement(Image, {
					image = images.claim.line.vertical,
					color = color,
					transparency = transparency,
					scaleType = Enum.ScaleType.Tile,
					tileSize = UDim2.new(1, 0, 0, 65),
					size = UDim2.new(0, 15, 1, -15),
					position = UDim2.fromScale(1, 0),
					anchorPoint = Vector2.new(1, 0)
				})
			})
		})
	})
end

return (hook(Claim, { componentType = "PureComponent" }))