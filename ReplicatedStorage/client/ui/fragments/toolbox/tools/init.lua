local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolType = require(ReplicatedStorage.shared.enum.ToolType)

local Draw = ToolType.Draw
local Draw2 = require(script.Draw)
local Tools = { [Draw] = Draw2 }

local Line = ToolType.Line
local Line2 = require(script.Line)
Tools[Line] = Line2
local Erase = ToolType.Erase
local Erase2 = require(script.Erase)
Tools[Erase] = Erase2
local Claim = ToolType.Claim
local Claim2 = require(script.Claim)
Tools[Claim] = Claim2
local Shape = ToolType.Shape
local Shape2 = require(script.Shape)
Tools[Shape] = Shape2
local Eyedropper = ToolType.Eyedropper
local Eyedropper2 = require(script.Eyedropper)
Tools[Eyedropper] = Eyedropper2
return Tools