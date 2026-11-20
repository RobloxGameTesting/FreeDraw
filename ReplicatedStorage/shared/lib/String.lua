local String = {}

function String.trim(value: string)
	return value:match("^%s*(.-)%s*$")
end

function String.duration(p: number)
	return `{math.floor(p / 86400)}d {math.floor(p / 3600) % 24}h {math.floor(p / 60) % 60}m {p % 60}s`
end

return String