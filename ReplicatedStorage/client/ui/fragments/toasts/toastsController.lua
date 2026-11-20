local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = require(ReplicatedStorage.shared.remotes)
local Maid = require(ReplicatedStorage.shared.class.Maid)
local toastsSlice = require(script.Parent.toastsSlice)
local Localization = require(ReplicatedStorage.shared.lib.Localization)

local showToast = remotes.Client:Get("showToast")

local function toastsController(object)
	local v = Maid.new({ showToast:Connect(function(p, p2, icon)
			object:dispatch(toastsSlice.thunks.showToast({
				text = Localization.String.new(p, p2),
				icon = icon
			}))
		end) })

	return function()
		v:clean()
	end
end

return toastsController