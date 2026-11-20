local RuntimeLib = require(script.Parent.Parent.TS.RuntimeLib)

local default = {}
function default:constructor(p)
	self.middlewares = p == nil and {} or p
end
function default._use(p, p2)
	local middlewares = p.middlewares

	middlewares[#middlewares + 1] = p2
end
function default._processMiddleware(p, p2)
	local middlewares = p.middlewares
	local v, v2 = RuntimeLib.try(function()
		if not (#middlewares > 0) then
			return RuntimeLib.TRY_RETURN, { p2 }
		end

		local v = p2

		for _, middleware in ipairs(middlewares) do
			v = middleware(v, p)
		end

		return RuntimeLib.TRY_RETURN, { v }
	end, function(p3)
		warn("[rbx-net] " .. tostring(p3))
	end)

	if v then
		return unpack(v2)
	end
end

return { default = default }