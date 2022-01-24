AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

------------------------------//
function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 15
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
	self.CurrentCombiner = nil
	self:SetIsInstalled(false)
	self:SetModel("models/zerochain/zmlab/zmlab_filter.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:UseClientSideAnimation()
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.PhysgunDisable = true
	self.FilterHealth = zmlab.config.FilterHealth
end

------------------------------//
------------------------------//
function ENT:Use(ply, caller)
	if (not self:IsValid()) then return end
	if (not zmlab.f.IsOwner(ply, self)) then return end

	if (self.CurrentCombiner) then
		self:Combiner_deattach(ply)
	end
end

function ENT:Combiner_attach(combiner)
	DropEntityIfHeld(self)
	self.CurrentCombiner = combiner
	self.CurrentCombiner.InstalledFilter = self
	local phys = self:GetPhysicsObject()
	self:SetPos(self.CurrentCombiner:GetAttachment(self.CurrentCombiner:LookupAttachment("input")).Pos + self.CurrentCombiner:GetUp() * 7)
	self:SetAngles(self.CurrentCombiner:GetAngles())
	zmlab.f.CreateEffectTable(nil, "filter_attach", self, self:GetAngles(), self:GetPos())
	phys:Wake()
	phys:EnableMotion(false)
	self:SetParent(self.CurrentCombiner)
	self:SetIsInstalled(true)
	self.CurrentCombiner:SetHasFilter(true)

	if (self.CurrentCombiner:GetStage() == 5) then
		zmlab.f.CreateAnimTable(self, "run", 1)
	end
end

function ENT:Combiner_deattach(ply)
	local phys = self:GetPhysicsObject()
	self:SetParent(nil)
	local pos = ply:GetPos() + ply:GetUp() * 10
	--pos = self.CurrentCombiner:GetAttachment(self.CurrentCombiner:LookupAttachment("input")).Pos + self.CurrentCombiner:GetUp() * 35 + self.CurrentCombiner:GetForward() * 40
	self:SetPos(pos)
	self:SetAngles(self.CurrentCombiner:GetAngles())
	phys:Wake()
	phys:EnableMotion(true)
	zmlab.f.CreateEffectTable(nil, "filter_dettach", self, self:GetAngles(), self:GetPos())
	zmlab.f.CreateAnimTable(self, "idle", 1)
	self:SetIsInstalled(false)
	self.CurrentCombiner.CheckInput = true
	self.CurrentCombiner:SetHasFilter(false)
	self.CurrentCombiner.InstalledFilter = nil
	self.CurrentCombiner = nil
end

------------------------------//
------------------------------//
function ENT:CheckHealth()
	if (self.lastHealth or 0 == self.FilterHealth) then return end
	self.lastHealth = self.FilterHealth

	if (zmlab.config.FilterHealth > 0 and self:GetIsInstalled() and self.CurrentCombiner:GetStage() == 5) then
		if (self.FilterHealth <= 0) then
			zmlab.f.CreateEffectTable(nil, "filter_break", self, self:GetAngles(), self:GetPos())
			self:Combiner_deattach()
			self:Remove()
		elseif (self.FilterHealth < zmlab.config.FilterHealth * 0.4) then
			self:SetSkin(2)
		elseif (self.FilterHealth < zmlab.config.FilterHealth * 0.75) then
			self:SetSkin(1)
		end

		if (self.FilterHealth > 0) then
			self.FilterHealth = self.FilterHealth - 1
		end
	end
end

function ENT:Think()
	self:CheckHealth()
end

-- Damage Stuff
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zmlab.config.Damageable["Filter"].EntityHealth

	if (entHealth > 0) then
		self.CurrentHealth = (self.CurrentHealth or entHealth) - damage

		if (self.CurrentHealth <= 0) then
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end
