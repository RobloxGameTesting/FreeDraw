local GetLuminance = require(script.Parent.GetLuminance)
local Lighten = require(script.Parent.Lighten)
local Darken = require(script.Parent.Darken)

return function(color: Color3, p: number, value: number?)
	return (type(value) == "number" and value or 0.5) < GetLuminance(color) and Darken(color, p) or Lighten(color, p)
end