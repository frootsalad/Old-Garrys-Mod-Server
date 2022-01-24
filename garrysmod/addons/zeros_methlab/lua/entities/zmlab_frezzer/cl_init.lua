include("shared.lua")

local laser = Material("cable/redlaser")

function ENT:Draw_FilterIndicator()
	render.SetMaterial(laser)
	local startPos = self:GetPos() + self:GetUp() * 5 + self:GetRight() * 22
	local endPos = startPos + self:GetUp() * 70
	render.DrawBeam(startPos, endPos, 5, 1, 1, Color(255, 0, 0, 0))
end

function ENT:Draw()
	self:DrawModel()
	if (LocalPlayer():GetPos():Distance(self:GetPos()) > 1000) then return end

	if (zmlab.config.debug) then
		self:Draw_FilterIndicator()
	end

	local dlight01 = DynamicLight(self:EntIndex())

	if (dlight01 and self:GetIsFrezzig()) then
		dlight01.pos = self:GetPos() + self:GetUp() * 50 + self:GetRight() * 20
		dlight01.r = 0
		dlight01.g = 200
		dlight01.b = 255
		dlight01.brightness = 2
		dlight01.Decay = 1000
		dlight01.Size = 300
		dlight01.DieTime = CurTime() + 1
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end
