include("shared.lua")

function ENT:OnRemove()
	self:StopParticles()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end
