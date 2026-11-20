local function noop(...)
	return ...
end

local v = { name = "boolean", encode = noop, decode = noop }

return {
	["environment.canvasColor"] = {
		type = {
			name = "color",
			encode = function(p)
				return p:ToHex()
			end,
			decode = function(p)
				return Color3.fromHex(p)
			end
		},
		default = Color3.new(1, 1, 1)
	},
	["environment.sky"] = {
		type = { name = "string", encode = noop, decode = noop },
		default = "default"
	},
	["privacy.hideRole"] = { type = v, default = false },
	["privacy.hideTime"] = { type = v, default = false },
	["privacy.hidePro"] = { type = v, default = false }
}