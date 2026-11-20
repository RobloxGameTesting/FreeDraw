local v = false
local v2 = 0
return function(state)
	local GuiService = game:GetService("GuiService")
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local v3 = {}
	local GoodSignal = require(script.Parent.Parent.Packages.GoodSignal)
	local v4 = GoodSignal.new()
	local guiInset = GuiService:GetGuiInset()
	local v5 = 0
	local v6 = 0
	local v7 = 0
	local count = 0
	local v8 = false
	local v9 = false
	local function checkInset(p)
		local height = GuiService.TopbarInset.Height
		local isOldTopbar = height <= 36

		v8 = GuiService:IsTenFootInterface()
		v9 = UserInputService.VREnabled
		state.isOldTopbar = isOldTopbar
		count += 1

		if height == 0 and p == nil then
			task.defer(function()
				task.wait(8)
				checkInset("ForceConvertToOld")
			end)
		elseif count == 1 then
			task.delay(5, function()
				Players.LocalPlayer:WaitForChild("PlayerGui")

				if count == 1 then
					checkInset()
				end
			end)
		end

		if state.isOldTopbar and not v8 and not v9 and v == false and (height ~= 0 or p == "ForceConvertToOld") then
			v = true
			task.defer(function()
				local themes = script.Parent.Parent.Features.Themes
				local Classic = require(themes.Classic)
				state.modifyBaseTheme(Classic)

				local function decideToHideTopbar() -- 1 equivalent call inferred from this helper
					if GuiService.MenuIsOpen then
						state.setTopbarEnabled(false, true)
					else
						state.setTopbarEnabled()
					end
				end
				GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(decideToHideTopbar)
				decideToHideTopbar() -- inferred equivalent call
			end)
		end

		guiInset = GuiService:GetGuiInset()
		v5 = isOldTopbar and 12 or guiInset.Y - 50
		v6 = isOldTopbar and 2 or 0
		v7 = -2

		if v8 then
			v5 = 10
			v6 = 0
		end

		if GuiService.TopbarInset.Height == 0 and not v then
			v6 += 13
			v7 = 50
		end

		v4:Fire(guiInset)
		local y = guiInset.Y

		if y ~= v2 then
			v2 = y
			task.defer(function()
				state.insetHeightChanged:Fire(y)
			end)
		end
	end
	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(checkInset)
	checkInset("FirstTime")

	local topbarStandard = Instance.new("ScreenGui")
	v4:Connect(function()
		topbarStandard:SetAttribute("StartInset", v5)
	end)
	topbarStandard.Name = "TopbarStandard"
	topbarStandard.Enabled = true
	topbarStandard.DisplayOrder = state.baseDisplayOrder
	topbarStandard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	topbarStandard.IgnoreGuiInset = true
	topbarStandard.ResetOnSpawn = false
	topbarStandard.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	v3[topbarStandard.Name] = topbarStandard
	state.baseDisplayOrderChanged:Connect(function()
		topbarStandard.DisplayOrder = state.baseDisplayOrder
	end)

	local holders = Instance.new("Frame")
	holders.Name = "Holders"
	holders.BackgroundTransparency = 1
	v4:Connect(function()
		local v10 = v9 and 36 or 56
		local udim

		if v8 then
			udim = UDim2.new(1, 0, 0, v10)
		else
			udim = UDim2.new(1, 0, 1, v7)
		end

		holders.Position = UDim2.new(0, 0, 0, v6)
		holders.Size = udim
	end)
	holders.Visible = true
	holders.ZIndex = 1
	holders.Parent = topbarStandard

	local topbarCentered = topbarStandard:Clone()
	local holders2 = topbarCentered.Holders
	local function updateCenteredHoldersHeight()
		holders2.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + v7)
	end
	topbarCentered.Name = "TopbarCentered"
	topbarCentered.DisplayOrder = state.baseDisplayOrder
	topbarCentered.ScreenInsets = Enum.ScreenInsets.None
	state.baseDisplayOrderChanged:Connect(function()
		topbarCentered.DisplayOrder = state.baseDisplayOrder
	end)
	v3[topbarCentered.Name] = topbarCentered

	v4:Connect(updateCenteredHoldersHeight)
	holders2.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + v7)

	local clone = topbarStandard:Clone()
	clone.Name ..= "Clipped"
	clone.DisplayOrder = state.baseDisplayOrder + 1
	state.baseDisplayOrderChanged:Connect(function()
		clone.DisplayOrder = state.baseDisplayOrder + 1
	end)
	v3[clone.Name] = clone

	local clone2 = topbarCentered:Clone()
	clone2.Name ..= "Clipped"
	clone2.DisplayOrder = state.baseDisplayOrder + 1
	state.baseDisplayOrderChanged:Connect(function()
		clone2.DisplayOrder = state.baseDisplayOrder + 1
	end)
	v3[clone2.Name] = clone2

	local left = Instance.new("ScrollingFrame")
	left:SetAttribute("IsAHolder", true)
	left.Name = "Left"
	v4:Connect(function()
		left.Position = UDim2.fromOffset(v5, 0)
	end)
	left.Size = UDim2.new(1, -24, 1, 0)
	left.BackgroundTransparency = 1
	left.Visible = true
	left.ZIndex = 1
	left.Active = false
	left.ClipsDescendants = true
	left.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	left.CanvasSize = UDim2.new(0, 0, 1, -1)
	left.AutomaticCanvasSize = Enum.AutomaticSize.X
	left.ScrollingDirection = Enum.ScrollingDirection.X
	left.ScrollBarThickness = 0
	left.BorderSizePixel = 0
	left.Selectable = false
	left.ScrollingEnabled = false
	left.ElasticBehavior = Enum.ElasticBehavior.Never
	left.Parent = holders

	local uiListLayout = Instance.new("UIListLayout")
	v4:Connect(function()
		uiListLayout.Padding = UDim.new(0, v5)
	end)
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.Parent = left

	local center = left:Clone()
	v4:Connect(function()
		center.UIListLayout.Padding = UDim.new(0, v5)
	end)
	center.ScrollingEnabled = false
	center.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	center.Name = "Center"
	center.Parent = holders2

	local right = left:Clone()
	v4:Connect(function()
		right.UIListLayout.Padding = UDim.new(0, v5)
	end)
	right.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	right.Name = "Right"
	right.AnchorPoint = Vector2.new(1, 0)
	right.Position = UDim2.new(1, -12, 0, 0)
	right.Parent = holders

	v4:Fire(guiInset)

	return v3
end