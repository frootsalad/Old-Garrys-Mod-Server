AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

------------------------------//
function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create("zmlab_frezzer")
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), -90)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zmlab.f.SetOwnerID(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel("models/zerochain/zmlab/zmlab_frezzer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.PhysgunDisable = true
	self:SetUsedPositions(0)
	self.TrayTable = {}
	self.TrayTable[1] = "empty"
	self.TrayTable[2] = "empty"
	self.TrayTable[3] = "empty"
	self.TrayTable[4] = "empty"
	self.TrayTable[5] = "empty"

	timer.Simple(0.1, function()
		if (IsValid(self)) then
			for i = 1, 5 do
				local tray = self:CreateProp("zmlab_frezzingtray", self:GetPos(), self:GetAngles())
				self:AddFrezzerTray(tray, i)
			end
		end
	end)
end

function ENT:StartTouch(other)
	if (self:GetUsedPositions() < 5 and IsValid(other) and other:GetClass() == "zmlab_frezzingtray" and (other.STATE == "SLUDGE" or other.STATE == "EMPTY")) then
		traypos = self:FindEmptyTrayPos()

		if (traypos) then
			self:AddFrezzerTray(other, traypos)
		end
	end
end

function ENT:FindEmptyTrayPos()
	local freeTrail

	for i = 1, table.Count(self.TrayTable) do
		if (self.TrayTable[i] == "empty") then
			freeTrail = i
			break
		end
	end

	if (freeTrail) then
		return freeTrail
	else
		return false
	end
end

function ENT:AddFrezzerTray(tray, trPos)
	self:SetUsedPositions(self:GetUsedPositions() + 1)
	DropEntityIfHeld(tray)
	local attach = self:GetAttachment(self:LookupAttachment("row0" .. trPos))
	tray:SetPos(attach.Pos + self:GetUp() * -2 + self:GetRight() * 9)
	tray:SetAngles(self:GetAngles())
	tray:SetParent(self, attach)
	self.TrayTable[trPos] = tray
	tray.PhysgunDisable = true
	tray.InFrezzer = true
	zmlab.f.CreateEffectTable(nil, "frezzer_addTray", self, self:GetAngles(), self:GetPos())
end

------------------------------//
------------------------------//
function ENT:Use(ply, caller)
	if (not self:IsValid()) then return end
	if ((self._zmlab_lastUsed or CurTime()) > CurTime()) then return end
	self._zmlab_lastUsed = CurTime() + 0.2
	if (not zmlab.f.IsOwner(ply, self)) then return end

	if (not self:RemoveMethTray()) then
		self:RemoveEmptyTray()
	end
end

function ENT:RemoveMethTray()
	for k, v in pairs(self.TrayTable) do
		if (v ~= "empty" and v:IsValid() and v.STATE == "METH") then
			self:RemoveFrezzerTray(v, k)

			return true
		end
	end
end

function ENT:RemoveEmptyTray()
	for k, v in pairs(self.TrayTable) do
		if (v ~= "empty" and IsValid(v) and v.STATE == "EMPTY") then
			self:RemoveFrezzerTray(v, k)

			return true
		end
	end
end
function ENT:RemoveFrezzerTray(tray, trPos)
	tray:SetParent(nil)
	tray:SetPos(self:GetPos() + self:GetUp() * 80 + self:GetRight() * 10 + self:GetRight() * (25 * trPos))
	tray:SetAngles(self:GetAngles())
	local phys = tray:GetPhysicsObject()
	phys:Wake()
	phys:EnableMotion(true)
	phys:SetAngleDragCoefficient(2)
	tray.PhysgunDisable = false
	self.TrayTable[trPos] = "empty"
	self:SetUsedPositions(self:GetUsedPositions() - 1)
	tray.InFrezzer = false
	zmlab.f.CreateEffectTable(nil, "frezzer_removeTray", self, self:GetAngles(), self:GetPos())
end

------------------------------//
------------------------------//
function ENT:FrezzingProcessor()
	local isFrezzing = false

	for k, v in pairs(self.TrayTable) do
		if (v ~= "empty" and IsValid(v) and v.STATE == "SLUDGE") then
			zmlab.f.CreateEffectTable("zmlab_frozen_tray", "progress_frezzing", v, v:GetAngles(), v:GetPos())
			isFrezzing = true

			if (v:GetFrezzingProgress() < zmlab.config.FrezzingProcess) then
				v:SetFrezzingProgress(v:GetFrezzingProgress() + 1)
			else
				v:ConvertSludge()
			end
		end
	end

	self:SetIsFrezzig(isFrezzing)
end

function ENT:Think()
	//self:Inputer()

	if ((self.lastfrezze or -1) < CurTime()) then
		self.lastfrezze = CurTime() + math.random(1, 2)
		self:FrezzingProcessor()
	end
end

------------------------------//
------------------------------//
function ENT:OnRemove()
end

function ENT:CreateProp(class, pos, ang)
	local ent = ents.Create(class)
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	self:DeleteOnRemove(ent)
	zmlab.f.SetOwnerID(ent, zmlab.f.GetOwner(self))

	return ent
end

------------------------------//
-- Damage Stuff
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zmlab.config.Damageable["Frezzer"].EntityHealth

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
