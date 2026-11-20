local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)

local Line = require(ReplicatedStorage.shared.render.Line)
local config = require(ReplicatedStorage.shared.data.config)
local optionsSlice = require(ReplicatedStorage.client.ui.fragments.options.optionsSlice)

local function lineGenericRenderer(callback)
	local v = {}

	return {
		render = function(self, p, p2)
			local v2 = callback(self)
			local v3 = callback(p)

			if Sift.Dictionary.count(v2) > 0 or Sift.Dictionary.count(v3) > 0 then
				local v4 = p2.index * config.layers.offset
				local options = optionsSlice.selectors.selectOptions(self)

				for k, v5 in v2 do
					local v6 = v[k]

					if v[k] then
						if self.layers.selectedLayer ~= p.layers.selectedLayer then
							v6:setOffset(v4)
							v6:setParent(p2.object)
						end
					else
						v6 = Line.new(options)
						v6:setOffset(v4)
						v6:setParent(p2.object)
						v[k] = v6
					end

					v6:render(v5)
				end

				for k in v3 do
					local v5 = v[k]

					if v2[k] or not v5 then
						continue
					end

					v5:setParent(nil)
					v[k] = nil
				end
			end
		end,
		destroy = function()
			for _, v2 in v do
				v2:destroy()
			end

			v = {}
		end
	}
end

return lineGenericRenderer