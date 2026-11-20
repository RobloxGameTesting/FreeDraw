local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)
local TopbarPlus = require(ReplicatedStorage.packages.TopbarPlus)

local hook = require(ReplicatedStorage.shared.util.hook)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local createElement = Roact.createElement
local LocalPlayer = Players.LocalPlayer

task.spawn(function()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	local topbarCentered = playerGui:WaitForChild("TopbarCentered")
	topbarCentered.DisplayOrder = 100
	local topbarCenteredClipped = playerGui:WaitForChild("TopbarCenteredClipped")
	topbarCenteredClipped.DisplayOrder = 100
	local topbarStandard = playerGui:WaitForChild("TopbarStandard")
	topbarStandard.DisplayOrder = 100
	local topbarStandardClipped = playerGui:WaitForChild("TopbarStandardClipped")
	topbarStandardClipped.DisplayOrder = 100
end)

local extended = Roact.Component:extend("TopbarButton")

function extended:init()
	self.icon = TopbarPlus.new()
	self:update({}, self.props)

	self.icon:bindEvent("selected", function(...)
		if self.props.onSelect then
			self.props.onSelect(...)
		end
	end)

	self.icon:bindEvent("deselected", function(...)
		if self.props.onDeselect then
			self.props.onDeselect(...)
		end
	end)
end

function extended:didUpdate(p)
	self:update(p, self.props)
end

function extended.willUnmount(p)
	p.icon:destroy()
end

function extended.render(_): nil
	return nil
end

function extended:update(data, data2)
	if data.name ~= data2.name then
		self.icon:setName(data2.name)
	end

	if data.label ~= data2.label then
		self.icon:setLabel(data2.label)
	end

	if data.caption ~= data2.caption then
		self.icon:setCaption(data2.caption)
	end

	if data.image ~= data2.image then
		self.icon:setImage(data2.image)
	end

	if data.imageScale ~= data2.imageScale then
		self.icon:setImageScale(data2.imageScale)
	end

	if data.toggle ~= data2.toggle then
		self.icon:oneClick(not data2.toggle)
	end

	if data.alignment ~= data2.alignment then
		self.icon:align(data2.alignment)
	end

	if data.order ~= data2.order then
		self.icon:setOrder(data2.order)
	end
end

local function TopbarButtonWrapper(p, p2)
	local v = Localization.localContext:useProvider(p2)

	return createElement(
		extended,
		Sift.Dictionary.join(p, { label = v:resolve(p.label), caption = v:resolve(p.caption) })
	)
end

return (hook(TopbarButtonWrapper, { componentType = "PureComponent" }))