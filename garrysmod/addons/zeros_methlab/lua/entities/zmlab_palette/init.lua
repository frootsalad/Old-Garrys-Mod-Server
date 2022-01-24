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
	--self:SetCollisionGroup( 1 )
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.PhysgunDisable = true
end

function ENT:StartTouch(ent)
	if IsValid(ent) and ent:GetClass() == "zmlab_collectcrate" then
		self:AddCrate(ent)
	end
end

function ENT:AddCrate(ent)
	if (ent:GetMethAmount() >= zmlab.config.TransportCrate_Capacity and self:GetCrateCount() < 12) then

		self:SetCrateCount(self:GetCrateCount() + 1)
		self:SetMethAmount(self:GetMethAmount() + ent:GetMethAmount())
		ent:Remove()
	end
end
