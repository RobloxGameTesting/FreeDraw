local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CmdrClient = require((ReplicatedStorage:WaitForChild("CmdrClient")))

CmdrClient:SetActivationKeys({ Enum.KeyCode.Semicolon })
CmdrClient:SetHideOnLostFocus(true)
CmdrClient:SetPlaceName("free-draw")

CmdrClient.Registry:RegisterHook("BeforeRun", function() end)

CmdrClient.Registry:RegisterCommandsIn(script.commands)

return true