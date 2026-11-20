local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(p)
	local v = { Items = {}, ItemOptions = {}, SelectedItem = 0 }

	local util = p.Util
	local dictionary = util.MakeDictionary({ "me", "all", ".", "*", "others" })

	local autocomplete = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Autocomplete")
	local textButton = autocomplete:WaitForChild("TextButton")
	local title = autocomplete:WaitForChild("Title")
	local description = autocomplete:WaitForChild("Description")
	local entry = autocomplete.Parent:WaitForChild("Frame"):WaitForChild("Entry")
	textButton.Parent = nil

	local function SetText(title2, field, name, p2) -- 2 equivalent calls inferred from this helper
		title2.Visible = name ~= nil
		field.Text = name or ""

		if p2 then
			field.Size = UDim2.new(
				0,
				util.GetTextSize(name or "", field, Vector2.new(1000, 1000), 1, 0).X,
				title2.Size.Y.Scale,
				title2.Size.Y.Offset
			)
		end
	end

	local function UpdateInfoDisplay(data)
		SetText(title, title.Field, data.name, true)
		SetText( -- inferred equivalent call
			title.Field.Type,
			title.Field.Type,
			data.type and ": " .. data.type:sub(1, 1):upper() .. data.type:sub(2)
		)
		SetText(description, description.Label, data.description) -- inferred equivalent call

		description.Label.TextColor3 = data.invalid and Color3.fromRGB(255, 73, 73) or Color3.fromRGB(255, 255, 255)

		local v2 = math.max(title.Field.TextBounds.X + title.Field.Type.TextBounds.X, autocomplete.Size.X.Offset)
		description.Size = UDim2.new(1, 0, 0, 40)

		while not description.Label.TextFits do
			description.Size += UDim2.new(0, 0, 0, 2)

			if description.Size.Y.Offset > 500 then
				break
			end
		end

		wait()
		autocomplete.UIListLayout:ApplyLayout()
		autocomplete.Size = UDim2.new(0, v2, 0, autocomplete.UIListLayout.AbsoluteContentSize.Y)
	end

	function v:Show(items, options)
		local v2 = options or {}

		for _, item in pairs(self.Items) do
			if item.gui then
				item.gui:Destroy()
			end
		end

		self.SelectedItem = 1
		self.Items = items
		self.Prefix = v2.prefix or ""
		self.LastItem = v2.isLast or false
		self.Command = v2.command
		self.Arg = v2.arg
		self.NumArgs = v2.numArgs
		self.IsPartial = v2.isPartial
		local v3 = 200

		for k, item in pairs(self.Items) do
			local text = item[1]
			local v4 = item[2]

			if dictionary[text] then
				text = v4
			end

			local clone = textButton:Clone()
			clone.Name = text .. v4
			clone.BackgroundTransparency = k == self.SelectedItem and 0.5 or 1
			clone.Typed.Text = text
			clone.Suggest.Text = string.rep(" ", #text) .. v4:sub(#text + 1)
			clone.Parent = autocomplete
			clone.LayoutOrder = k

			local v5 = math.max(clone.Typed.TextBounds.X, clone.Suggest.TextBounds.X) + 20

			if v3 < v5 then
				v3 = v5
			end

			item.gui = clone
		end

		autocomplete.UIListLayout:ApplyLayout()

		local text = entry.TextBox.Text
		local splitString = util.SplitString(text)

		if text:sub(#text, #text) == " " and not v2.at then
			splitString[#splitString + 1] = "e"
		end

		table.remove(splitString, #splitString)
		local v4 = (v2.at and v2.at or #table.concat(splitString, " ") + 1) * 7

		autocomplete.Position = UDim2.new(
			0,
			entry.TextBox.AbsolutePosition.X - 10 + v4,
			0,
			entry.TextBox.AbsolutePosition.Y + 30
		)
		autocomplete.Size = UDim2.new(0, v3, 0, autocomplete.UIListLayout.AbsoluteContentSize.Y)
		autocomplete.Visible = true

		v2 = self.Items[1] and self.Items[1].options or v2
		UpdateInfoDisplay(v2)
	end

	function v.GetSelectedItem(_)
		if autocomplete.Visible == false then
			return nil
		end

		return v.Items[v.SelectedItem]
	end

	function v.Hide(_)
		autocomplete.Visible = false
	end

	function v.IsVisible(_)
		return autocomplete.Visible
	end

	function v:Select(p2)
		if not autocomplete.Visible then
			return
		end

		self.SelectedItem += p2

		if self.SelectedItem > #self.Items then
			self.SelectedItem = 1
		elseif self.SelectedItem < 1 then
			self.SelectedItem = #self.Items
		end

		for k, item in pairs(self.Items) do
			item.gui.BackgroundTransparency = k == self.SelectedItem and 0.5 or 1
		end

		if self.Items[self.SelectedItem] and self.Items[self.SelectedItem].options then
			UpdateInfoDisplay(self.Items[self.SelectedItem].options or {})
		end
	end

	return v
end