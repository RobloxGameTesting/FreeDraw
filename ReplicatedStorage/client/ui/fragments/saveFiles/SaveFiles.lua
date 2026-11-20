local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local RoactRodux = require(ReplicatedStorage.packages.RoactRodux)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Container = require(ReplicatedStorage.client.ui.components.base.Container)
local Box = require(ReplicatedStorage.client.ui.components.base.Box)
local colors = require(ReplicatedStorage.client.ui.assets.colors)
local SaveFilesAutosave = require(script.Parent.SaveFilesAutosave)
local SaveFilesDetails = require(script.Parent.SaveFilesDetails)
local SaveFilesList = require(script.Parent.SaveFilesList)
local ScreenSelector = require(ReplicatedStorage.client.ui.components.template.ScreenSelector)

local createElement = Roact.createElement

local function SaveFilesContent(props, _)
	if props.paginated then
		return createElement(ScreenSelector, {
			index = props.saveFileSelected and 2 or 1,
			size = props.size,
			position = props.position,
			anchorPoint = props.anchorPoint
		}, {
			ListContainer = createElement(Container, {
				layoutOrder = 1,
				size = UDim2.fromScale(1, 1)
			}, {
				List = createElement(SaveFilesList, Sift.Dictionary.join(props, {
					size = UDim2.fromScale(1, 1)
				})),
				Padding = createElement("UIPadding", {
					PaddingTop = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 20),
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20)
				})
			}),
			DetailsContainer = createElement(Container, {
				layoutOrder = 2,
				size = UDim2.fromScale(1, 1)
			}, {
				Details = createElement(
					SaveFilesDetails,
					Sift.Dictionary.join(props, {
						includesBackButton = true,
						size = UDim2.fromScale(1, 1)
					})
				),
				Padding = createElement("UIPadding", {
					PaddingTop = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 20),
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20)
				})
			})
		})
	end

	return createElement(Container, {
		size = props.size,
		position = props.position,
		anchorPoint = props.anchorPoint
	}, {
		List = createElement(SaveFilesList, { size = UDim2.new(1, -240, 1, 0) }),
		Details = createElement(SaveFilesDetails, {
			size = UDim2.new(0, 200, 1, 0),
			position = UDim2.fromScale(1, 0),
			anchorPoint = Vector2.new(1, 0)
		}),
		Divider = createElement(
			Box,
			{
				color = colors.grey[300],
				size = UDim2.new(0, 1, 1, 0),
				position = UDim2.new(1, -220, 0.5, 0),
				anchorPoint = Vector2.new(0, 0.5)
			},
			{
				Gradient = createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.1, 0),
						NumberSequenceKeypoint.new(0.9, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}
		),
		Padding = createElement("UIPadding", {
			PaddingTop = UDim.new(0, 20),
			PaddingBottom = UDim.new(0, 20),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20)
		})
	})
end

local function SaveFiles(props)
	local active = props.autosave and props.autosave.active

	local v = { size = props.size }
	local autosave

	if active then
		autosave = createElement(SaveFilesAutosave, {
			autosave = props.autosave,
			size = UDim2.new(1, 0, 0, 48)
		})
	end

	local v2 = SaveFilesContent
	local v3 = { paginated = props.paginated, size = 0, position = 0, anchorPoint = 0 }
	local size

	if active then
		size = UDim2.new(1, 0, 1, -48)
	else
		size = UDim2.fromScale(1, 1)
	end

	v3.size = size
	v3.position = UDim2.fromScale(0, 1)
	v3.anchorPoint = Vector2.new(0, 1)
	return createElement(Container, v, { Autosave = autosave, Content = createElement(v2, v3) })
end

SaveFilesContent = hook(SaveFilesContent, { componentType = "PureComponent" })
local v = hook(SaveFiles, {
	componentType = "PureComponent",
	defaultProps = { size = UDim2.fromScale(1, 1) }
})

SaveFilesContent = RoactRodux.connect(function(p)
	return {
		saveFileSelected = p.saveFiles.selectedSaveFile and true or false
	}
end)(SaveFilesContent)

return (RoactRodux.connect(function(p)
	return { autosave = p.saveFiles.autosave }
end)(v))