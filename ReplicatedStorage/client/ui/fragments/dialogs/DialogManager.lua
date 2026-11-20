local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.packages.Roact)
local Sift = require(ReplicatedStorage.packages.Sift)

local hook = require(ReplicatedStorage.shared.util.hook)
local Dialog = require(script.Parent.Dialog)

local createElement = Roact.createElement
local createFragment = Roact.createFragment

local function DialogManager(p, data)
	local state, setState = data.useState({})

	data.useEffect(function()
		if p.dialog then
			setState(function(p2)
				return Sift.Dictionary.set(p2, p.dialog.id, p.dialog)
			end)
		end
	end, { p.dialog })

	local onDestroy = data.useCallback(function(p2)
		setState(function(p3)
			return Sift.Dictionary.removeKey(p3, p2)
		end)
	end, {})

	return createFragment(Sift.Dictionary.map(state, function(p2)
		local active

		if p.dialog then
			active = p.dialog.id == p2.id
		else
			active = false
		end

		return createElement(Dialog, {
			active = active,
			id = p2.id,
			options = p2.options,
			onClose = p.onClose,
			onDestroy = onDestroy
		})
	end))
end

return (hook(DialogManager, { componentType = "PureComponent" }))