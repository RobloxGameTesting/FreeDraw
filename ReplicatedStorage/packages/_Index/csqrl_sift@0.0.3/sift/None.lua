local v = newproxy(true)

getmetatable(v).__tostring = function(): string
	return "Sift.None"
end

return v