AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 35
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 90)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zmlab.f.SetOwnerID(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.emitTime = -1
	self.OnCombiner = false
	self.PhysgunDisable = true
end

function ENT:IsLookingDown()
	if (self:GetAngles().z > -180 and self:GetAngles().z < -160) then
		return true
	elseif (self:GetAngles().z > 160 and self:GetAngles().z < 180) then
		return true
	else
		return false
	end
end

function ENT:ShakeLogic()
	if ((self:GetVelocity():Length() > 200) and (self:GetVelocity():Length() < 1000) and self.emitTime < CurTime()) then
		zmlab.f.CreateEffectTable("zmlab_aluminium_drops", "Aluminium_walk", self, self:GetAngles(), self:GetPos())
		self.emitTime = CurTime() + 0.3
	end
end

function ENT:PhysicsCollide(data, phys)
	if (data.Speed > 50 and self.emitTime < CurTime()) then
		zmlab.f.CreateEffectTable("zmlab_aluminium_drops", "Aluminium_walk", self, self:GetAngles(), self:GetPos())
		self.emitTime = CurTime() + 0.3
	end
end

function ENT:Think()
	if (not self.OnCombiner) then
		self:ShakeLogic()
	end
end
