local function make(className: string, p, items)
	local instance = Instance.new(className)

	if items then
		for k, item in items do
			instance:SetAttribute(k, item)
		end
	end

	if not p then
		return instance
	end

	for k, v in p do
		if k ~= "Parent" then
			instance[k] = v
		end
	end

	instance.Parent = p.Parent

	return instance
end

return make