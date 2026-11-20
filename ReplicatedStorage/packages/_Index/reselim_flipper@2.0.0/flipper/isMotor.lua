local function isMotor(p)
	local match = tostring(p):match("^Motor%((.+)%)$")

	if match then
		return true, match
	end

	return false
end

return isMotor