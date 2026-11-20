local StarterGui = game:GetService("StarterGui")

return {
	Name = "setcoreguienabled",
	Aliases = { "coregui", "cg", "setcore" },
	Description = "Sets a CoreGui's status.",
	Group = "Player",
	Args = {
		{ Name = "coreGuiType", Type = "robloxCoreGuiType" },
		{
			Name = "enabled",
			Type = "boolean",
			Description = "Whether the specified CoreGui should be enabled"
		}
	},
	Run = function(_, p, p2)
		StarterGui:SetCoreGuiEnabled(p, p2)

		if p2 then
			return ("Successfully enabled %s."):format(p)
		end

		return ("Successfully disabled %s."):format(p)
	end
}