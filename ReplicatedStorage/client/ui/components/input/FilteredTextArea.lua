local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local Image = require(ReplicatedStorage.client.ui.components.base.Image)
local TextArea = require(ReplicatedStorage.client.ui.components.input.TextArea)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local images = require(ReplicatedStorage.client.ui.assets.images)
local TextFilterStatus = require(ReplicatedStorage.shared.enum.TextFilterStatus)
local Response = require(ReplicatedStorage.shared.lib.Response)
local remotes = require(ReplicatedStorage.shared.remotes)

local requestTextFilter = remotes.Client:Get("requestTextFilter")

local v = {
	[TextFilterStatus.Loading] = { icon = images.textEntry.loading, color = colors.grey[400] },
	[TextFilterStatus.Filtered] = { icon = images.textEntry.filtered, color = colors.red[700] },
	[TextFilterStatus.Unfiltered] = {
		icon = images.textEntry.unfiltered,
		color = colors.green[700]
	}
}

local createElement = Roact.createElement

local function FilteredTextArea(props, props2)
	local state, setState = props2.useState(TextFilterStatus.Loading)
	local v2 = v[state]

	local v3 = props2.useValue("")
	local v4 = props2.useValue(false)
	local function filter(p)
		if not v4.value then
			v4.value = true
			setState(TextFilterStatus.Loading)
			requestTextFilter:CallServerAsync(p):andThen(Response.promisify):andThen(function(p2)
				if p2.isFiltered then
					setState(TextFilterStatus.Filtered)
				else
					setState(TextFilterStatus.Unfiltered)
				end
			end):finally(function()
				v4.value = false

				local value = v3.value

				if value ~= p then
					filter(value)
				end
			end)
		end
	end

	return createElement(Container, {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex
	}, {
		TextArea = createElement(TextArea, {
			placeholder = props.placeholder,
			size = UDim2.fromScale(1, 1),
			filter = props.filter,
			onUpdate = props2.useCallback(function(p)
				v3.value = p
				filter(p)
				props.onUpdate(p)
			end, { props.onUpdate })
		}),
		Icon = createElement(Image, {
			image = v2.icon,
			color = v2.color,
			size = UDim2.fromOffset(12, 12),
			position = UDim2.new(1, -16, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			zIndex = 10
		}),
		Border = createElement(Box, {
			borderColor = v2.color,
			transparency = 1,
			radius = 8,
			size = UDim2.fromScale(1, 1),
			zIndex = 10
		})
	})
end

return (hook(FilteredTextArea, { componentType = "PureComponent" }))