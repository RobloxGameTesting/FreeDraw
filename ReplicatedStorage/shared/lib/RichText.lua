local function tag(p: string, p2: string, items)
	if not (items and next(items)) then
		return ("<%s>%s</%s>"):format(p, p2, p)
	end

	local v = {}

	for k, item in items do
		table.insert(v, ("%s=\"%s\""):format(k, item))
	end

	return ("<%s %s>%s</%s>"):format(p, table.concat(v, " "), p2, p)
end

local RichText = {}

function RichText.colored(p: string, color: Color3)
	return tag("font", p, {
		color = "#" .. color:ToHex()
	})
end

function RichText.font(p: string, p2)
	local face

	if p2.font then
		face = p2.font.Name
	end

	return tag("font", p, { face = face, size = p2.size })
end

function RichText.stroke(p: string, data)
	local color

	if data.color then
		color = "#" .. data.color:ToHex()
	end

	local v = {
		color = color,
		thickness = data.thickness,
		transparency = data.transparency,
		joins = 0
	}
	local joins

	if data.mode then
		joins = data.mode.Name
	end

	v.joins = joins
	return tag("stroke", p, v)
end

function RichText.bold(p: string)
	return tag("b", p)
end

function RichText.italic(p: string)
	return tag("i", p)
end

function RichText.underline(p: string)
	return tag("u", p)
end

function RichText.strike(p: string)
	return tag("s", p)
end

function RichText.smallCaps(p: string)
	return tag("sc", p)
end

function RichText.uppercase(p: string)
	return tag("uc", p)
end

return RichText