local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Roact = require(ReplicatedStorage.packages.Roact)

local Localization = require(ReplicatedStorage.shared.lib.Localization)
local Claim = require(ReplicatedStorage.client.ui.fragments.claims.Claim)
local config = require(ReplicatedStorage.shared.data.config)
local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local LocalPlayer = Players.LocalPlayer
local createElement = Roact.createElement

local function getClaimError(props) -- 1 equivalent call inferred from this helper
	if props.size.X < config.tools.claim.bounds.min.X or props.size.Y < config.tools.claim.bounds.min.Y then
		return Localization.String.new("claim.error.tooSmall")
	end
end

local function claimRenderer()
	local v = nil

	local function element(props)
		return createElement(Localization.localContext.component, nil, {
			Claim = createElement(Claim, {
				player = LocalPlayer,
				temporary = true,
				error = getClaimError(props), -- inferred equivalent call
				position = props.position,
				rotation = props.rotation,
				size = props.size
			})
		})
	end

	return {
		render = function(p, p2)
			local tool = p.toolbox.tools[ToolType.Claim]

			if tool ~= p2.toolbox.tools[ToolType.Claim] then
				if tool and not v then
					v = Roact.mount(element(tool), Workspace, "ClaimPreview")
				elseif not tool and v then
					Roact.unmount(v)
					v = nil
				end

				if tool and v then
					Roact.update(v, element(tool))
				end
			end
		end,
		destroy = function()
			if v then
				Roact.unmount(v)
			end
		end
	}
end

return claimRenderer