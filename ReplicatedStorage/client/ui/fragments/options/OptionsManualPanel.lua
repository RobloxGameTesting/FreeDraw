local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local IconButton = require(ReplicatedStorage.client.ui.components.button.IconButton)
local Field = require(ReplicatedStorage.client.ui.components.input.Field)
local LabelDecoration = require(ReplicatedStorage.client.ui.components.input.decoration.LabelDecoration)
local FieldDecoration = require(ReplicatedStorage.client.ui.components.input.decoration.FieldDecoration)
local Slider = require(ReplicatedStorage.client.ui.components.input.Slider)
local colorSlice = require(script.Parent.optionSlices.colorSlice)
local Binding = require(ReplicatedStorage.shared.lib.Binding)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local function filterNumber(value) -- 1 equivalent call inferred from this helper
	return value:gsub("%D", "")
end

local function filterHex(value) -- 1 equivalent call inferred from this helper
	return value:gsub("%X", ""):upper()
end

local function filterConstrainedNumber(min, max) -- 6 equivalent calls inferred from this helper
	return function(value)
		local v = filterNumber(value) -- inferred equivalent call

		if tonumber(v) then
			return (math.clamp(v, min, max))
		end

		return v
	end
end

local createElement = Roact.createElement

local function OptionsDecoratedSlider(props)
	return createElement(FieldDecoration, {
		value = props.value,
		placeholder = props.value,
		filter = props.filter,
		size = UDim2.fromOffset(52, 28),
		layoutOrder = props.layoutOrder,
		onUpdate = props.onUpdate
	}, {
		Slider = createElement(Slider, {
			value = props.value,
			min = props.min,
			max = props.max,
			step = 1,
			gradient = props.gradient,
			color = props.color,
			onUpdate = props.onUpdate
		})
	})
end

local function OptionsManualPanel(props, p)
	local mapPluck = Binding.mapPluck(props.color, "rgb")
	local mapPluck2 = Binding.mapPluck(props.color, "hsv")

	local v = {
		size = props.size or UDim2.fromScale(1, 0),
		position = props.position,
		automaticSize = Enum.AutomaticSize.Y,
		layoutOrder = props.layoutOrder,
		[Roact.Change.AbsoluteSize] = p.useCallback(function(p2)
			props.onSize(p2.AbsoluteSize)
		end, { props.onSize })
	}

	local v2 = {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		layoutOrder = 3
	}

	local v3 = {
		label = Localization.String.new("options.color.manual.rgb"),
		layoutOrder = 1
	}

	local v4 = { size = UDim2.fromScale(1, 0), automaticSize = Enum.AutomaticSize.Y }
	local children = {
		Red = createElement(OptionsDecoratedSlider, {
			value = Binding.mapPluck(mapPluck, "red"):map(function(p2)
				return (math.floor(p2 * 255))
			end),
			min = 0,
			max = 255,
			step = 1,
			filter = p.useCallback(filterConstrainedNumber(0, 255), {}), -- inferred equivalent call
			gradient = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
			}),
			layoutOrder = 1,
			onUpdate = p.useCallback(function(p2)
				local v5 = tonumber(p2)

				if v5 then
					props.setRGB(v5 / 255, nil, nil)
				end
			end, { props.setRGB })
		}),
		Green = 0,
		Blue = 0,
		Layout = 0
	}

	children.Green = createElement(OptionsDecoratedSlider, {
		value = Binding.mapPluck(mapPluck, "green"):map(function(p2)
			return (math.floor(p2 * 255))
		end),
		min = 0,
		max = 255,
		step = 1,
		filter = p.useCallback(filterConstrainedNumber(0, 255), {}), -- inferred equivalent call
		gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 1, 0))
		}),
		layoutOrder = 2,
		onUpdate = p.useCallback(function(p2)
			local v5 = tonumber(p2)

			if v5 then
				props.setRGB(nil, v5 / 255, nil)
			end
		end, { props.setRGB })
	})

	children.Blue = createElement(OptionsDecoratedSlider, {
		value = Binding.mapPluck(mapPluck, "blue"):map(function(p2)
			return (math.floor(p2 * 255))
		end),
		min = 0,
		max = 255,
		step = 1,
		filter = p.useCallback(filterConstrainedNumber(0, 255), {}), -- inferred equivalent call
		gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 1))
		}),
		layoutOrder = 3,
		onUpdate = p.useCallback(function(p2)
			local v5 = tonumber(p2)

			if v5 then
				props.setRGB(nil, nil, v5 / 255)
			end
		end, { props.setRGB })
	})

	children.Layout = createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4)
	})
	local children2 = {
		RGB = createElement(LabelDecoration, v3, {
			Content = createElement(Container, v4, children)
		}),
		HSV = 0,
		Footer = 0,
		Layout = 0
	}

	local v5 = {
		label = Localization.String.new("options.color.manual.hsv"),
		layoutOrder = 2
	}

	local v6 = { size = UDim2.fromScale(1, 0), automaticSize = Enum.AutomaticSize.Y }
	local children3 = {
		Hue = createElement(OptionsDecoratedSlider, {
			value = Binding.mapPluck(mapPluck2, "hue"):map(function(p2)
				return (math.floor(p2 * 360))
			end),
			min = 0,
			max = 360,
			step = 1,
			filter = p.useCallback(filterConstrainedNumber(0, 360), {}), -- inferred equivalent call
			gradient = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
				ColorSequenceKeypoint.new(1 / 6, Color3.new(1, 1, 0)),
				ColorSequenceKeypoint.new(1 / 3, Color3.new(0, 1, 0)),
				ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)),
				ColorSequenceKeypoint.new(2 / 3, Color3.new(0, 0, 1)),
				ColorSequenceKeypoint.new(5 / 6, Color3.new(1, 0, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
			}),
			layoutOrder = 1,
			onUpdate = p.useCallback(function(p2)
				local v7 = tonumber(p2)

				if v7 then
					props.setHSV(v7 / 360, nil, nil)
				end
			end, { props.setHSV })
		}),
		Saturation = 0,
		Value = 0,
		Layout = 0
	}

	children3.Saturation = createElement(OptionsDecoratedSlider, {
		value = Binding.mapPluck(mapPluck2, "saturation"):map(function(p2)
			return (math.floor(p2 * 100))
		end),
		min = 0,
		max = 100,
		step = 1,
		filter = p.useCallback(filterConstrainedNumber(0, 100), {}), -- inferred equivalent call
		gradient = Binding.mapPluck(mapPluck2, "hue"):map(function(p2)
			return ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(p2, 0, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(p2, 1, 1))
			})
		end),
		layoutOrder = 2,
		onUpdate = p.useCallback(function(p2)
			local v7 = tonumber(p2)

			if v7 then
				props.setHSV(nil, v7 / 100, nil)
			end
		end, { props.setHSV })
	})

	children3.Value = createElement(OptionsDecoratedSlider, {
		value = Binding.mapPluck(mapPluck2, "value"):map(function(p2)
			return (math.floor(p2 * 100))
		end),
		min = 0,
		max = 100,
		step = 1,
		filter = p.useCallback(filterConstrainedNumber(0, 100), {}), -- inferred equivalent call
		gradient = Binding.mapPluck(mapPluck2, "hue"):map(function(p2)
			return ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(p2, 1, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(p2, 1, 1))
			})
		end),
		layoutOrder = 3,
		onUpdate = p.useCallback(function(p2)
			local v7 = tonumber(p2)

			if v7 then
				props.setHSV(nil, nil, v7 / 100)
			end
		end, { props.setHSV })
	})

	children3.Layout = createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4)
	})
	children2.HSV = createElement(LabelDecoration, v5, {
		Content = createElement(Container, v6, children3),
		Hex = createElement(
			LabelDecoration,
			{
				label = Localization.String.new("options.color.manual.hex"),
				layoutOrder = 3
			},
			{
				Field = createElement(Field, {
					value = mapPluck:map(function(data)
						return (("%02x%02x%02x"):format(data.red * 255, data.green * 255, data.blue * 255)):upper()
					end),
					filter = p.useCallback(function(value)
						return filterHex(value):sub(1, 6) -- inferred equivalent call
					end, {}),
					onUpdate = p.useCallback(function(value)
						if #value == 3 then
							local v7 = tonumber(value:sub(1, 1):rep(2), 16)
							local v8 = tonumber(value:sub(2, 2):rep(2), 16)
							local v9 = tonumber(value:sub(3, 3):rep(2), 16)

							props.setRGB(v7 / 255, v8 / 255, v9 / 255)
						elseif #value == 6 then
							local v7 = tonumber(value:sub(1, 2), 16)
							local v8 = tonumber(value:sub(3, 4), 16)
							local v9 = tonumber(value:sub(5, 6), 16)

							props.setRGB(v7 / 255, v8 / 255, v9 / 255)
						end
					end, {}),
					size = UDim2.new(1, 0, 0, 32)
				})
			}
		)
	})
	local footer

	if props.backButton then
		footer = createElement(Container, { size = UDim2.new(1, 0, 0, 24), layoutOrder = 10 }, {
			Back = createElement(IconButton, {
				icon = "back",
				color = colors.grey[900],
				size = UDim2.fromOffset(32, 32),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				onClick = props.onBack
			})
		})
	end

	children2.Footer = footer

	children2.Layout = createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 28)
	})
	return createElement(Container, v, {
		Inputs = createElement(Container, v2, children2),
		Layout = createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 20)
		}),
		Padding = createElement("UIPadding", {
			PaddingTop = UDim.new(0, 20),
			PaddingBottom = UDim.new(0, 20),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20)
		})
	})
end

OptionsDecoratedSlider = hook(OptionsDecoratedSlider, { componentType = "PureComponent" })
local v = hook(OptionsManualPanel, { componentType = "PureComponent" })

local bindingConverter = Binding.createBindingConverter(v, { "color" })

return (RoactRodux.connect(function(p)
	return { color = p.options.color }
end, function(callback)
	return {
		setRGB = function(p, p2, p3)
			callback(colorSlice.actions.setRGB(p, p2, p3))
		end,
		setHSV = function(p, p2, p3)
			callback(colorSlice.actions.setHSV(p, p2, p3))
		end
	}
end)(bindingConverter))