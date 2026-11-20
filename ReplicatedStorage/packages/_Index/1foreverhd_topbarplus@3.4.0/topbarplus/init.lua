local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
require(script.Types)

local script = script
local Reference = require(script.Reference)
local object = Reference.getObject()
local value = object and object.Value

if value and value ~= script then
	local module = require(value)
	return module
end

if not object then
	Reference.addToReplicatedStorage()
end

local GoodSignal = require(script.Packages.GoodSignal)
local Janitor = require(script.Packages.Janitor)
local Utility = require(script.Utility)
local Themes = require(script.Features.Themes)
local Gamepad = require(script.Features.Gamepad)
local Overflow = require(script.Features.Overflow)
local Topbarplus = {}
Topbarplus.__index = Topbarplus

local LocalPlayer = Players.LocalPlayer
local themes = script.Features.Themes
local iconsDictionary = {}
local v = GoodSignal.new()
local elements = script.Elements
local count = 0
local v2 = {
	mobile = Enum.PreferredInput.Touch,
	desktop = Enum.PreferredInput.KeyboardAndMouse,
	console = Enum.PreferredInput.Gamepad
}

Topbarplus.baseDisplayOrderChanged = GoodSignal.new()
Topbarplus.baseDisplayOrder = 10
Topbarplus.baseTheme = require(themes.Default)
Topbarplus.isOldTopbar = false
Topbarplus.iconsDictionary = iconsDictionary
Topbarplus.insetHeightChanged = GoodSignal.new()
local Container = require(elements.Container)
Topbarplus.container = Container(Topbarplus)
Topbarplus.topbarEnabled = true
Topbarplus.iconAdded = GoodSignal.new()
Topbarplus.iconRemoved = GoodSignal.new()
Topbarplus.iconChanged = GoodSignal.new()

function Topbarplus.getIcons()
	return Topbarplus.iconsDictionary
end

function Topbarplus.getIconByUID(p)
	return Topbarplus.iconsDictionary[p] or nil
end

function Topbarplus.getIcon(p)
	local iconByUID = Topbarplus.getIconByUID(p)

	if iconByUID then
		return iconByUID
	end

	for _, v3 in pairs(iconsDictionary) do
		if v3.name == p then
			return v3
		end
	end

	return nil
end

function Topbarplus.setTopbarEnabled(p, p2)
	if typeof(p) ~= "boolean" then
		p = Topbarplus.topbarEnabled
	end

	if not p2 then
		Topbarplus.topbarEnabled = p
	end

	for _, v3 in pairs(Topbarplus.container) do
		v3.Enabled = p
	end
end

function Topbarplus.modifyBaseTheme(p)
	local modifications = Themes.getModifications(p)

	for _, modification in pairs(modifications) do
		for _, v3 in pairs(Topbarplus.baseTheme) do
			Themes.merge(v3, modification)
		end
	end

	for _, v3 in pairs(iconsDictionary) do
		v3:setTheme(Topbarplus.baseTheme)
	end
end

function Topbarplus.setDisplayOrder(baseDisplayOrder)
	Topbarplus.baseDisplayOrder = baseDisplayOrder
	Topbarplus.baseDisplayOrderChanged:Fire(baseDisplayOrder)
end

task.defer(Gamepad.start, Topbarplus)
task.defer(Overflow.start, Topbarplus)
task.defer(function()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")

	for _, v3 in pairs(Topbarplus.container) do
		v3.Parent = playerGui
	end

	require(script.Attribute)
end)

function Topbarplus.new()
	local class = {}
	setmetatable(class, Topbarplus)

	local janitor = Janitor.new()
	class.janitor = janitor
	class.themesJanitor = janitor:add(Janitor.new())
	class.singleClickJanitor = janitor:add(Janitor.new())
	class.captionJanitor = janitor:add(Janitor.new())
	class.joinJanitor = janitor:add(Janitor.new())
	class.menuJanitor = janitor:add(Janitor.new())
	class.dropdownJanitor = janitor:add(Janitor.new())

	local uid = Utility.generateUID()
	iconsDictionary[uid] = class
	janitor:add(function()
		iconsDictionary[uid] = nil
	end)

	class.selected = janitor:add(GoodSignal.new())
	class.deselected = janitor:add(GoodSignal.new())
	class.toggled = janitor:add(GoodSignal.new())
	class.viewingStarted = janitor:add(GoodSignal.new())
	class.viewingEnded = janitor:add(GoodSignal.new())
	class.stateChanged = janitor:add(GoodSignal.new())
	class.notified = janitor:add(GoodSignal.new())
	class.noticeStarted = janitor:add(GoodSignal.new())
	class.noticeChanged = janitor:add(GoodSignal.new())
	class.endNotices = janitor:add(GoodSignal.new())
	class.toggleKeyAdded = janitor:add(GoodSignal.new())
	class.fakeToggleKeyChanged = janitor:add(GoodSignal.new())
	class.alignmentChanged = janitor:add(GoodSignal.new())
	class.updateSize = janitor:add(GoodSignal.new())
	class.resizingComplete = janitor:add(GoodSignal.new())
	class.joinedParent = janitor:add(GoodSignal.new())
	class.menuSet = janitor:add(GoodSignal.new())
	class.dropdownSet = janitor:add(GoodSignal.new())
	class.updateMenu = janitor:add(GoodSignal.new())
	class.startMenuUpdate = janitor:add(GoodSignal.new())
	class.childThemeModified = janitor:add(GoodSignal.new())
	class.indicatorSet = janitor:add(GoodSignal.new())
	class.dropdownChildAdded = janitor:add(GoodSignal.new())
	class.menuChildAdded = janitor:add(GoodSignal.new())

	class.iconModule = script
	class.UID = uid
	class.isEnabled = true
	class.enabled = class.isEnabled
	class.isSelected = false
	class.isViewing = false
	class.joinedFrame = false
	class.parentIconUID = false
	class.deselectWhenOtherIconSelected = true
	class.totalNotices = 0
	class.activeState = "Deselected"
	class.alignment = ""
	class.originalAlignment = ""
	class.appliedTheme = {}
	class.appearance = {}
	class.cachedInstances = {}
	class.cachedNamesToInstances = {}
	class.cachedCollectives = {}
	class.bindedToggleKeys = {}
	class.customBehaviours = {}
	class.toggleItems = {}
	class.bindedEvents = {}
	class.notices = {}
	class.menuIcons = {}
	class.dropdownIcons = {}
	class.childIconsDict = {}
	class.creationTime = os.clock()

	local Widget = require(elements.Widget)
	class.widget = janitor:add(Widget(class, Topbarplus))
	class:setAlignment()

	count += 1
	local v3 = count * 0.01 + 1
	class:setOrder(v3, "deselected")
	class:setOrder(v3, "selected")

	class:setTheme(Topbarplus.baseTheme)

	local instance = class:getInstance("ClickRegion")
	local v4 = false
	local v5 = 0

	local function handleToggle() -- 3 equivalent calls inferred from this helper
		if class.locked then
			return
		end

		local now = tick()

		if now - v5 < 0.1 then
			return
		end

		v5 = now

		if class.isSelected then
			class:deselect("User", class)
		else
			class:select("User", class)
		end
	end

	instance.MouseButton1Click:Connect(function()
		v4 = true
		handleToggle() -- inferred equivalent call
	end)

	instance.TouchTap:Connect(function()
		if not v4 then
			handleToggle() -- inferred equivalent call
		end
	end)

	janitor:add(UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if class.locked then
			return
		end

		if class.bindedToggleKeys[input.KeyCode] and not gameProcessed then
			handleToggle() -- inferred equivalent call
		end
	end))

	local function viewingStarted(p) -- 2 equivalent calls inferred from this helper
		if class.locked then
			return
		end

		class.isViewing = true
		class.viewingStarted:Fire(true)

		if not p then
			class:setState("Viewing", "User", class)
		end
	end
	local function viewingEnded() -- 1 equivalent call inferred from this helper
		if class.locked then
			return
		end

		class.isViewing = false
		class.viewingEnded:Fire(true)
		class:setState(nil, "User", class)
	end
	class.joinedParent:Connect(function()
		if class.isViewing then
			viewingEnded() -- inferred equivalent call
		end
	end)
	instance.MouseEnter:Connect(function()
		viewingStarted(UserInputService.PreferredInput ~= v2.desktop) -- inferred equivalent call
	end)
	local count2 = 0
	janitor:add(UserInputService.TouchEnded:Connect(viewingEnded))
	instance.MouseLeave:Connect(viewingEnded)
	instance.SelectionGained:Connect(viewingStarted)
	instance.SelectionLost:Connect(viewingEnded)
	instance.MouseButton1Down:Connect(function()
		if not class.locked and UserInputService.PreferredInput == v2.mobile then
			count2 += 1
			local v6 = count2
			task.delay(0.2, function()
				if v6 == count2 then
					viewingStarted(false) -- inferred equivalent call
				end
			end)
		end
	end)
	instance.MouseButton1Up:Connect(function()
		count2 += 1
	end)

	local instance2 = class:getInstance("IconOverlay")
	class.viewingStarted:Connect(function()
		instance2.Visible = not class.overlayDisabled
	end)
	class.viewingEnded:Connect(function()
		instance2.Visible = false
	end)

	janitor:add(v:Connect(function(p)
		if p ~= class and class.deselectWhenOtherIconSelected and p.deselectWhenOtherIconSelected then
			class:deselect("AutoDeselect", p)
		end
	end))

	local v6 = debug.info(2, "s")
	local v7 = string.split(v6, ".")
	local game = game
	local originsScreenGui = nil

	for _, childName in pairs(v7) do
		game = game:FindFirstChild(childName)

		if game then
			if game:IsA("ScreenGui") then
				originsScreenGui = game
			end
		else
			break
		end
	end

	if game and originsScreenGui and originsScreenGui.ResetOnSpawn == true then
		class.originsScreenGui = originsScreenGui
		Utility.localPlayerRespawned(function()
			class:destroy()
		end)
	end

	class.toggled:Connect(function(p)
		class.noticeChanged:Fire(class.totalNotices)

		for k, _ in pairs(class.childIconsDict) do
			local iconByUID = Topbarplus.getIconByUID(k)
			iconByUID.noticeChanged:Fire(iconByUID.totalNotices)

			if p or not iconByUID.isSelected then
				continue
			end

			for _, _ in pairs(iconByUID.childIconsDict) do
				iconByUID:deselect("HideParentFeature", class)
			end
		end
	end)

	class.selected:Connect(function()
		if #class.dropdownIcons > 0 then
			if StarterGui:GetCore("ChatActive") and class.alignment ~= "Right" then
				class.chatWasPreviouslyActive = true
				StarterGui:SetCore("ChatActive", false)
			end

			if StarterGui:GetCoreGuiEnabled("PlayerList") and class.alignment ~= "Left" then
				class.playerlistWasPreviouslyActive = true
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			end
		end
	end)
	class.deselected:Connect(function()
		if class.chatWasPreviouslyActive then
			class.chatWasPreviouslyActive = nil
			StarterGui:SetCore("ChatActive", true)
		end

		if class.playerlistWasPreviouslyActive then
			class.playerlistWasPreviouslyActive = nil
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		end
	end)

	task.delay(0.1, function()
		if class.activeState == "Deselected" then
			class.stateChanged:Fire("Deselected")
			class:refresh()
		end
	end)

	Topbarplus.iconAdded:Fire(class)

	return class
end

function Topbarplus:setName(name)
	self.widget.Name = name
	self.name = name
	return self
end

function Topbarplus:setState(p, p2, p3)
	local v3 = p or self.isSelected and "Selected" or "Deselected"

	local formatStateName = Utility.formatStateName(v3)

	if self.activeState == formatStateName then
		return
	end

	local isSelected = self.isSelected
	self.activeState = formatStateName

	if formatStateName == "Deselected" then
		self.isSelected = false

		if isSelected then
			self.toggled:Fire(false, p2, p3)
			self.deselected:Fire(p2, p3)
		end

		self:_setToggleItemsVisible(false, p2, p3)
	elseif formatStateName == "Selected" then
		self.isSelected = true

		if not isSelected then
			self.toggled:Fire(true, p2, p3)
			self.selected:Fire(p2, p3)
			v:Fire(self, p2, p3)
		end

		self:_setToggleItemsVisible(true, p2, p3)
	end

	self.stateChanged:Fire(formatStateName, p2, p3)
end

function Topbarplus:getInstance(p)
	local cachedNamesToInstance = self.cachedNamesToInstances[p]

	if cachedNamesToInstance then
		return cachedNamesToInstance
	end

	local function cacheInstance(p2, instance)
		if not self.cachedInstances[instance] then
			local collective = instance:GetAttribute("Collective")
			local instances = collective and self.cachedCollectives[collective]

			if instances then
				table.insert(instances, instance)
			end

			self.cachedNamesToInstances[p2] = instance
			self.cachedInstances[instance] = true
			instance.Destroying:Once(function()
				self.cachedNamesToInstances[p2] = nil
				self.cachedInstances[instance] = nil
			end)
		end
	end
	local widget = self.widget
	cacheInstance("Widget", widget)

	if p == "Widget" then
		return widget
	end

	local v3 = nil
	local function scanChildren(widget2)
		for _, child in pairs(widget2:GetChildren()) do
			local widgetUID = child:GetAttribute("WidgetUID")

			if not (not widgetUID or widgetUID == self.UID) then
				continue
			end

			local instance = Themes.getRealInstance(child) or child

			scanChildren(instance)

			if not (instance:IsA("GuiBase") or instance:IsA("UIBase") or instance:IsA("ValueBase")) then
				continue
			end

			local name = instance.Name
			cacheInstance(name, instance)

			if name == p then
				v3 = instance
			end
		end
	end
	scanChildren(widget)
	return v3
end

function Topbarplus:getCollective(p)
	local cachedCollective = self.cachedCollectives[p]

	if cachedCollective then
		return cachedCollective
	end

	local result = {}

	for k, _ in pairs(self.cachedInstances) do
		if k:GetAttribute("Collective") == p then
			table.insert(result, k)
		end
	end

	self.cachedCollectives[p] = result
	return result
end

function Topbarplus:getInstanceOrCollective(p)
	local instances = {}
	local instance = self:getInstance(p)

	if instance then
		table.insert(instances, instance)
	end

	if #instances == 0 then
		instances = self:getCollective(p)
	end

	return instances
end

function Topbarplus.getStateGroup(p, p2)
	local v3 = p2 or p.activeState
	local stateGroup = p.appearance[v3]

	if not stateGroup then
		stateGroup = {}
		p.appearance[v3] = stateGroup
	end

	return stateGroup
end

function Topbarplus:refreshAppearance(p, p2)
	Themes.refresh(self, p, p2)
	return self
end

function Topbarplus:refresh()
	self:refreshAppearance(self.widget)
	self.updateSize:Fire()
	return self
end

function Topbarplus:updateParent()
	local iconByUID = Topbarplus.getIconByUID(self.parentIconUID)

	if iconByUID then
		iconByUID.updateSize:Fire()
	end
end

function Topbarplus:setBehaviour(p, p2, p3, p4)
	local v3 = p .. "-" .. p2
	self.customBehaviours[v3] = p3

	if p4 then
		local instanceOrCollective = self:getInstanceOrCollective(p)

		for _, v4 in pairs(instanceOrCollective) do
			self:refreshAppearance(v4, p2)
		end
	end
end

function Topbarplus:modifyTheme(p, p2)
	return self, (Themes.modify(self, p, p2))
end

function Topbarplus:modifyChildTheme(childModifications, childModificationsUID)
	self.childModifications = childModifications
	self.childModificationsUID = childModificationsUID

	for k, _ in pairs(self.childIconsDict) do
		Topbarplus.getIconByUID(k):modifyTheme(childModifications, childModificationsUID)
	end

	self.childThemeModified:Fire()
	return self
end

function Topbarplus.removeModification(p, p2)
	Themes.remove(p, p2)
	return p
end

function Topbarplus.removeModificationWith(p, p2, p3, p4)
	Themes.removeWith(p, p2, p3, p4)
	return p
end

function Topbarplus:setTheme(p)
	Themes.set(self, p)
	return self
end

function Topbarplus:setEnabled(p)
	self.isEnabled = p
	self.enabled = self.isEnabled
	self.widget.Visible = p
	self:updateParent()
	return self
end

function Topbarplus:select(p, p2)
	self:setState("Selected", p, p2)
	return self
end

function Topbarplus:deselect(p, p2)
	self:setState("Deselected", p, p2)
	return self
end

function Topbarplus:notify(p, p2)
	if not self.notice then
		local Notice = require(elements.Notice)
		self.notice = Notice(self, Topbarplus)
	end

	self.noticeStarted:Fire(p, p2)
	return self
end

function Topbarplus:clearNotices()
	self.endNotices:Fire()
	return self
end

function Topbarplus:disableOverlay(overlayDisabled)
	self.overlayDisabled = overlayDisabled
	return self
end

Topbarplus.disableStateOverlay = Topbarplus.disableOverlay

function Topbarplus:setImage(p, p2)
	self:modifyTheme({ "IconImage", "Image", p, p2 })

	task.spawn(function()
		local v3

		if tonumber(p) then
			v3 = `rbxassetid://{p}`
		else
			v3 = p
		end

		if ContentProvider:GetAssetFetchStatus(v3) ~= Enum.AssetFetchStatus.Success then
			pcall(ContentProvider.PreloadAsync, ContentProvider, { v3 })
		end
	end)

	return self
end

function Topbarplus:setLabel(p, p2)
	self:modifyTheme({ "IconLabel", "Text", p, p2 })
	return self
end

function Topbarplus:setOrder(p, p2)
	local v3 = p * 100
	self:modifyTheme({ "IconSpot", "LayoutOrder", v3, p2 })
	self:modifyTheme({ "Widget", "LayoutOrder", v3, p2 })
	return self
end

function Topbarplus:setCornerRadius(p, p2)
	self:modifyTheme({ "IconCorners", "CornerRadius", p, p2 })
	return self
end

function Topbarplus:align(p, p2)
	local lower = tostring(p):lower()
	local v3 = (lower == "mid" or lower == "centre") and "center" or lower
	local v4 = v3 ~= "left" and v3 ~= "center" and v3 ~= "right" and "left" or v3
	local topbarCentered = v4 == "center" and Topbarplus.container.TopbarCentered or Topbarplus.container.TopbarStandard
	local holders = topbarCentered.Holders
	local v5 = string.upper((string.sub(v4, 1, 1))) .. string.sub(v4, 2)

	if not p2 then
		self.originalAlignment = v5
	end

	local joinedFrame = self.joinedFrame
	local holder = holders[v5]
	self.screenGui = topbarCentered
	self.alignmentHolder = holder

	if not self.isDestroyed then
		self.widget.Parent = joinedFrame or holder
	end

	self.alignment = v5
	self.alignmentChanged:Fire(v5)
	Topbarplus.iconChanged:Fire(self)
	return self
end

Topbarplus.setAlignment = Topbarplus.align

function Topbarplus.setLeft(object2)
	object2:setAlignment("Left")
	return object2
end

function Topbarplus.setMid(object2)
	object2:setAlignment("Center")
	return object2
end

function Topbarplus.setRight(object2)
	object2:setAlignment("Right")
	return object2
end

function Topbarplus:setWidth(p, p2)
	self:modifyTheme({ "Widget", "DesiredWidth", p, p2 })
	return self
end

function Topbarplus:setImageScale(p, p2)
	self:modifyTheme({ "IconImageScale", "Value", p, p2 })
	return self
end

function Topbarplus:setImageRatio(p, p2)
	self:modifyTheme({ "IconImageRatio", "AspectRatio", p, p2 })
	return self
end

function Topbarplus:setTextSize(p, p2)
	self:modifyTheme({ "IconLabel", "TextSize", p, p2 })
	return self
end

function Topbarplus:setTextFont(value2, p, p2, p3)
	local v3 = p or Enum.FontWeight.Regular
	local v4 = p2 or Enum.FontStyle.Normal
	local font = nil
	local typeName = typeof(value2)

	if typeName == "number" then
		font = Font.fromId(value2, v3, v4)
	elseif typeName == "EnumItem" then
		font = Font.fromEnum(value2)
	elseif typeName == "string" and not value2:match("rbxasset") then
		font = Font.fromName(value2, v3, v4)
	end

	self:modifyTheme({
		"IconLabel",
		"FontFace",
		font or Font.new(value2, v3, v4),
		p3
	})
	return self
end

function Topbarplus:setTextColor(p, p2)
	if p == nil or p == "" or type(p) ~= "userdata" or typeof(p) ~= "Color3" then
		if p ~= nil and p ~= "" then
			warn("setTextColor item must be a Color3 value! Changed the color to white.")
		end

		p = Color3.fromRGB(255, 255, 255)
	end

	self:modifyTheme({ "IconLabel", "TextColor3", p, p2 })
	return self
end

function Topbarplus:bindToggleItem(instance)
	if not (instance:IsA("GuiObject") or instance:IsA("LayerCollector")) then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end

	self.toggleItems[instance] = true
	self:_updateSelectionInstances()
	return self
end

function Topbarplus:unbindToggleItem(p)
	self.toggleItems[p] = nil
	self:_updateSelectionInstances()
	return self
end

function Topbarplus:_updateSelectionInstances()
	for folder, _ in pairs(self.toggleItems) do
		local buttons = {}

		for _, button in pairs(folder:GetDescendants()) do
			if not ((button:IsA("TextButton") or button:IsA("ImageButton")) and button.Active) then
				continue
			end

			table.insert(buttons, button)
		end

		self.toggleItems[folder] = buttons
	end
end

function Topbarplus:_setToggleItemsVisible(p, _, p2)
	for layerCollector, _ in pairs(self.toggleItems) do
		if not p2 or p2 == self or p2.toggleItems[layerCollector] == nil then
			layerCollector[layerCollector:IsA("LayerCollector") and "Enabled" or "Visible"] = p
		end
	end
end

function Topbarplus:bindEvent(p, callback)
	local v3 = self[p]
	local v4

	if v3 then
		v4 = typeof(v3) == "table" and v3.Connect
	else
		v4 = v3
	end

	assert(v4, "argument[1] must be a valid topbarplus icon event name!")
	assert(typeof(callback) == "function", "argument[2] must be a function!")
	self.bindedEvents[p] = v3:Connect(function(...)
		callback(self, ...)
	end)
	return self
end

function Topbarplus.unbindEvent(p, p2)
	local bindedEvent = p.bindedEvents[p2]

	if bindedEvent then
		bindedEvent:Disconnect()
		p.bindedEvents[p2] = nil
	end

	return p
end

function Topbarplus:bindToggleKey(p)
	assert(typeof(p) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.bindedToggleKeys[p] = true
	self.toggleKeyAdded:Fire(p)
	self:setCaption("_hotkey_")
	return self
end

function Topbarplus.unbindToggleKey(p, p2)
	assert(typeof(p2) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	p.bindedToggleKeys[p2] = nil
	return p
end

function Topbarplus.call(p, callback, ...)
	local v3 = table.pack(...)
	task.spawn(function()
		callback(p, table.unpack(v3))
	end)
	return p
end

function Topbarplus:addToJanitor(p, p2, p3)
	self.janitor:add(p, p2, p3)
	return self
end

function Topbarplus:lock()
	local instance = self:getInstance("ClickRegion")
	instance.Visible = false
	self.locked = true
	return self
end

function Topbarplus:unlock()
	local instance = self:getInstance("ClickRegion")
	instance.Visible = true
	self.locked = false
	return self
end

function Topbarplus:debounce(duration)
	self:lock()
	task.wait(duration)
	self:unlock()
	return self
end

function Topbarplus:autoDeselect(p)
	self.deselectWhenOtherIconSelected = p == nil or p
	return self
end

function Topbarplus:oneClick(p)
	local singleClickJanitor = self.singleClickJanitor
	singleClickJanitor:clean()

	if p or p == nil then
		singleClickJanitor:add(self.selected:Connect(function()
			self:deselect("OneClick", self)
		end))
	end

	self.oneClickEnabled = true
	return self
end

function Topbarplus:setCaption(captionText)
	if captionText == "_hotkey_" and self.captionText then
		return self
	end

	local captionJanitor = self.captionJanitor
	self.captionJanitor:clean()

	if captionText and captionText ~= "" then
		local Caption = require(elements.Caption)
		local caption = captionJanitor:add(Caption(self))
		caption:SetAttribute("CaptionText", captionText)
		self.caption = caption
		self.captionText = captionText
		return self
	end

	self.caption = nil
	self.captionText = nil
	return self
end

function Topbarplus:setCaptionHint(fakeToggleKey)
	assert(typeof(fakeToggleKey) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.fakeToggleKey = fakeToggleKey
	self.fakeToggleKeyChanged:Fire(fakeToggleKey)
	self:setCaption("_hotkey_")
	return self
end

function Topbarplus:leave()
	self.joinJanitor:clean()
	return self
end

function Topbarplus.joinMenu(p, object2)
	Utility.joinFeature(p, object2, object2.menuIcons, object2:getInstance("Menu"))
	object2.menuChildAdded:Fire(p)
	return p
end

function Topbarplus:setMenu(p)
	self.menuSet:Fire(p)
	return self
end

function Topbarplus:setFixedMenu(p)
	self:freezeMenu(p)
	self:setMenu(p)
end
Topbarplus.setFrozenMenu = Topbarplus.setFixedMenu

function Topbarplus:freezeMenu()
	self:select("FrozenMenu", self)
	self:bindEvent("deselected", function(object2)
		object2:select("FrozenMenu", self)
	end)
	self:modifyTheme({ "IconSpot", "Visible", false })
end

function Topbarplus.joinDropdown(p, object2)
	object2:getDropdown()
	Utility.joinFeature(p, object2, object2.dropdownIcons, object2:getInstance("DropdownScroller"))
	object2.dropdownChildAdded:Fire(p)
	return p
end

function Topbarplus:getDropdown()
	local dropdown = self.dropdown

	if dropdown then
		return dropdown
	end

	local Dropdown = require(elements.Dropdown)
	dropdown = Dropdown(self)
	self.dropdown = dropdown
	self:clipOutside(dropdown)

	return dropdown
end

function Topbarplus:setDropdown(p)
	self:getDropdown()
	self.dropdownSet:Fire(p)
	return self
end

function Topbarplus:clipOutside(p)
	local clipOutside = Utility.clipOutside(self, p)
	self:refreshAppearance(p)
	return self, clipOutside
end

function Topbarplus:setIndicator(p)
	if not self.indicator then
		local janitor = self.janitor
		local Indicator = require(elements.Indicator)
		self.indicator = janitor:add(Indicator(self, Topbarplus))
	end

	self.indicatorSet:Fire(p)
end

function Topbarplus:convertLabelToNumberSpinner(state, callback)
	task.defer(function()
		local instance = self:getInstance("IconLabel")
		instance.Transparency = 1
		state.Parent = instance.Parent
		state.Size = UDim2.fromScale(1, 1)
		state.AnchorPoint = Vector2.new(0.5, 0.5)
		state.Position = UDim2.new(0.5, 0, 0.5, 0)
		state.TextXAlignment = Enum.TextXAlignment.Center
		state.ClipsDescendants = false

		for _, propertyName in ipairs({
			"FontFace",
			"BorderSizePixel",
			"BorderColor3",
			"Rotation",
			"TextStrokeTransparency",
			"TextStrokeColor3",
			"TextStrokeTransparency",
			"TextColor3"
		}) do
			state[propertyName] = instance[propertyName]
			self:addToJanitor(instance:GetPropertyChangedSignal(propertyName):Connect(function()
				state[propertyName] = instance[propertyName]
			end))
		end

		local function getSpinnerSizeAndDigitCount()
			local total = 0
			local count2 = 0

			for _, child in state.Frame:GetChildren() do
				local name = string.lower(child.Name)

				if name == "digit" then
					total += child.AbsoluteSize.X
					count2 += 1
				elseif (name == "prefix" or name == "suffix" or name == "comma") and child.Text ~= "" then
					total += child.AbsoluteSize.X
					count2 += 1
				end
			end

			return total, count2
		end

		local function getLabelParentContainerXSize() -- 2 equivalent calls inferred from this helper
			local parent = instance.Parent
			local parent2 = parent and parent.Parent

			if parent2 == nil then
				return 0
			end

			if parent2.IconImage.Visible == true then
				return state.Frame.AbsoluteSize.X + instance.Parent.Parent.IconImage.AbsoluteSize.X
			end

			return parent2.AbsoluteSize.X
		end

		local function getNumberSpinnerXSize() -- 2 equivalent calls inferred from this helper
			return state.Frame.AbsoluteSize.X
		end

		local function adjustSize()
			local v3, v4 = getSpinnerSizeAndDigitCount()

			if v4 < 18 then
				self:setLabel(state.Value)
			end

			local numberSpinnerXSize = getNumberSpinnerXSize() -- inferred equivalent call

			while v3 < numberSpinnerXSize and self.isDestroyed ~= true do
				task.wait(0.05)

				if v4 > 0 and v4 < 8 then
					state.TextSize = instance.TextSize
					break
				end

				state.TextSize += 1
				numberSpinnerXSize = getNumberSpinnerXSize() -- inferred equivalent call
				v3, v4 = getSpinnerSizeAndDigitCount()
			end

			local labelParentContainerXSize = getLabelParentContainerXSize() -- inferred equivalent call

			while labelParentContainerXSize < v3 and self.isDestroyed ~= true do
				task.wait(0.05)

				if v4 < 8 and v4 > 0 then
					state.TextSize = instance.TextSize
					break
				end

				state.TextSize -= 1
				labelParentContainerXSize = getLabelParentContainerXSize() -- inferred equivalent call
				v3, v4 = getSpinnerSizeAndDigitCount()
			end
		end

		self:addToJanitor(state.Frame.ChildAdded:Connect(adjustSize))
		self:addToJanitor(state.Frame.ChildRemoved:Connect(adjustSize))
		self:addToJanitor(self.iconAdded:Connect(function()
			task.wait(1)
			adjustSize()
		end))

		self:updateParent()

		state.Name = "LabelSpinner"
		state.Prefix = "$"
		state.Commas = true
		state.Decimals = 0
		state.Duration = 0.25
		state.Value = 10
		task.wait(0.2)

		if typeof(callback) == "function" then
			callback()
		end
	end)
	return self
end

function Topbarplus:destroy()
	if self.isDestroyed then
		return
	end

	self:clearNotices()

	if self.parentIconUID then
		self:leave()
	end

	self.isDestroyed = true
	self.janitor:clean()
	Topbarplus.iconRemoved:Fire(self)
end
Topbarplus.Destroy = Topbarplus.destroy

return Topbarplus