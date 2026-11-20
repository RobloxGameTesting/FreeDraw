local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require(ReplicatedStorage.shared.class.Maid)
local input = require(script.Parent.input)
local tools = require(script.Parent.tools)

local function cursorController(object)
	local v = {}
	local v2 = {}

	local function handlePassiveInput(currentPassiveInput)
		local selectedTool = object:getState().toolbox.selectedTool

		local cursor = selectedTool and tools[selectedTool].cursor

		if cursor then
			local v3

			if currentPassiveInput.active then
				v3 = cursor()
				v3.render(currentPassiveInput.position, object:getState())
			else
				v3 = nil
			end

			v2[currentPassiveInput] = Maid.new({
				currentPassiveInput.onActive:connect(function(p)
					if not v3 then
						v3 = cursor()
						v3.render(p, object:getState())
					end
				end),
				currentPassiveInput.onInactive:connect(function()
					if v3 then
						v3.destroy()
						v3 = nil
					end
				end),
				currentPassiveInput.onMove:connect(function(p)
					v3.render(p, object:getState())
				end),
				currentPassiveInput.onDestroy:connect(function()
					v2[currentPassiveInput]:clean()
				end),
				function()
					if v3 then
						v3.destroy()
					end

					v2[currentPassiveInput] = nil
				end
			})
		end
	end

	local v3 = Maid.new({
		object.changed:connect(function(p, p2)
			local selectedTool = p.toolbox.selectedTool
			local selectedTool2 = p2.toolbox.selectedTool

			if selectedTool ~= selectedTool2 then
				if selectedTool2 then
					for _, v3 in v do
						v3.destroy()
					end

					v = {}

					for _, v3 in v2 do
						v3:clean()
					end
				end

				if selectedTool then
					for _, currentPassiveInput in input.currentPassiveInputs do
						handlePassiveInput(currentPassiveInput)
					end
				end
			end
		end),
		input.onPassiveInput:connect(handlePassiveInput)
	})

	return function()
		v3:clean()

		for _, v4 in v2 do
			v4:clean()
		end
	end
end

return cursorController