local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)

local actionCreator = Rodux.makeActionCreator("options/color/setRGB", function(red, green, blue)
	return { red = red, green = green, blue = blue }
end)

local actionCreator2 = Rodux.makeActionCreator("options/color/setHSV", function(hue, saturation, p)
	return { hue = hue, saturation = saturation, value = p }
end)

local actionCreator3 = Rodux.makeActionCreator("options/color/swap", function()
	return {}
end)

return {
	reducer = Rodux.createReducer({
		primary = Color3.new(0, 0, 0),
		secondary = Color3.new(1, 1, 1),
		rgb = { red = 0, green = 0, blue = 0 },
		hsv = { hue = 0, saturation = 0, value = 0 }
	}, {
		[actionCreator.name] = function(p, data)
			local red = data.red or p.rgb.red
			local green = data.green or p.rgb.green
			local blue = data.blue or p.rgb.blue

			local color = Color3.new(red, green, blue)
			local hsv, saturation, v = color:ToHSV()

			return {
				primary = color,
				secondary = p.secondary,
				rgb = { red = red, green = green, blue = blue },
				hsv = {
					hue = hsv % 1,
					saturation = saturation,
					value = v
				}
			}
		end,
		[actionCreator2.name] = function(p, data)
			local hue = data.hue or p.hsv.hue
			local saturation = data.saturation or p.hsv.saturation
			local value = data.value or p.hsv.value

			local color = Color3.fromHSV(hue, saturation, value)

			return {
				primary = color,
				secondary = p.secondary,
				rgb = { red = color.R, green = color.G, blue = color.B },
				hsv = { hue = hue, saturation = saturation, value = value }
			}
		end,
		[actionCreator3.name] = function(p)
			local secondary = p.secondary
			local hsv, saturation, v = secondary:ToHSV()

			return {
				primary = secondary,
				secondary = p.primary,
				rgb = { red = secondary.R, green = secondary.G, blue = secondary.B },
				hsv = { hue = hsv, saturation = saturation, value = v }
			}
		end
	}),
	actions = { setRGB = actionCreator, setHSV = actionCreator2, swap = actionCreator3 }
}