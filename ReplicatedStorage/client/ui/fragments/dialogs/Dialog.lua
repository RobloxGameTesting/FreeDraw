local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Text = require(ReplicatedStorage.client.ui.components.base.Text)
local ModalGUI = require(ReplicatedStorage.client.ui.components.template.gui.ModalGUI)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local TextButton = require(ReplicatedStorage.client.ui.components.button.TextButton)
local ButtonStyle = require(ReplicatedStorage.shared.enum.ButtonStyle)
local dialogsSlice = require(script.Parent.dialogsSlice)
local fonts = require(ReplicatedStorage.client.ui.assets.fonts)

local embedComponents = {
	image = require(script.Parent.embedComponents.ImageEmbed),
	textArea = require(script.Parent.embedComponents.TextAreaEmbed),
	dropdown = require(script.Parent.embedComponents.DropdownEmbed)
}

local createElement = Roact.createElement

local function Dialog(props, p)
	local options = props.options

	local children = {}

	if options.title then
		children.Title = createElement(Text, {
			text = options.title,
			font = Font.new(fonts.Builder, Enum.FontWeight.Bold),
			fontSize = 28,
			lineHeight = 1.2,
			color = colors.grey[900],
			textXAlignment = Enum.TextXAlignment.Left,
			wrapped = true,
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = Sift.Dictionary.count(children) + 1
		})
	end

	if options.description then
		children.Description = createElement(Text, {
			text = options.description,
			font = Font.new(fonts.Builder, Enum.FontWeight.Regular),
			fontSize = 18,
			lineHeight = 1.2,
			color = colors.grey[900],
			textXAlignment = Enum.TextXAlignment.Left,
			wrapped = true,
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			layoutOrder = Sift.Dictionary.count(children) + 1
		})
	end

	local v = p.useValue({})

	if options.embeds and #options.embeds > 0 then
		for k, embed in options.embeds do
			local id = embed.id or k
			children[("Embed(%s)"):format(id)] = createElement(embedComponents[embed.type], {
				id = id,
				options = embed.options,
				layoutOrder = Sift.Dictionary.count(children) + 1,
				onState = function(p2)
					v.value = Sift.Dictionary.set(v.value, id, p2)
				end
			})
		end
	end

	if options.buttons and #options.buttons > 0 then
		local children2 = {}

		for k, button in options.buttons do
			children2[button.id] = createElement(TextButton, {
				text = button.text,
				style = button.style or ButtonStyle.Flat,
				color = button.color,
				layoutOrder = k,
				onClick = function()
					props.onClose()
					props.onInteract(options.id, button.id, options.context, v.value)
				end
			})
		end

		children.Buttons = createElement(Container, {
			size = UDim2.new(1, 0, 0, 36),
			layoutOrder = Sift.Dictionary.count(children) + 1
		}, Sift.Dictionary.join(children2, {
			Layout = createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			})
		}))
	end

	return createElement(ModalGUI, {
		gui = ("DialogGUI(%s)"):format(props.id),
		active = props.active,
		onAnimationFinish = p.useCallback(function(p2)
			if not p2 then
				props.onDestroy(props.id)
			end
		end, { props.id }),
		onClose = props.onClose
	}, {
		Container = createElement(
			Container,
			{ size = UDim2.fromOffset(320, 0), automaticSize = Enum.AutomaticSize.Y },
			Sift.Dictionary.join(children, {
				Layout = createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12)
				}),
				Padding = createElement("UIPadding", {
					PaddingTop = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 20),
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20)
				})
			})
		)
	})
end

local v = hook(Dialog, { componentType = "PureComponent" })

return (RoactRodux.connect(nil, function(callback)
	return {
		onInteract = function(p, p2, p3, p4)
			callback(dialogsSlice.actions.interact(p, p2, p3, p4))
		end
	}
end)(v))