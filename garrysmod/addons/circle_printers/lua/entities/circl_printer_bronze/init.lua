/*---------------------------------------------------------------------------
Tomas
---------------------------------------------------------------------------*/
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString( "UPCCS" )

local function UpdateCircleClientSide(ent)
	local tabls = {}
	tabls.Money = ent.Money
	tabls.Speed = ent.Speed
	tabls.Heat = ent.Heat
	tabls.Cooler = ent.Cooler
	tabls.PlusMoney = ent.PlusMoney
	tabls.LvlExp = ent.LvlExp
	tabls.NextPrint = ent.NextPrint
	tabls.PrintRate = ent.PrintRate

	net.Start( "UPCCS" )
		net.WriteTable( tabls )
		net.WriteEntity( ent )
	net.Broadcast()	
end

function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetModel("models/props_c17/consolebox01a.mdl")
	
	self.ModelColor = Color(47, 56, 90, 255)
	self.ModelMaterial = "models/debug/debugwhite"

	if self.CrclCfg.ModelMaterial then self.ModelMaterial = self.CrclCfg.ModelMaterial end
	if self.CrclCfg.ModelColor then self.ModelColor = self.CrclCfg.ModelColor end

	if self.ModelMaterial != "nomat" then
		self:SetMaterial( self.ModelMaterial )
	end

	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor(self.ModelColor)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.Working = true
	self.PlayerPressedE = true

	self.MaxMoney = 5000
	self.PlusMoney = 100
	self.PrintRate = 10
	self.PlusSpeed = 20
	self.SpeedPrice = 500
	self.CoolerPrice = 1000

	self.Money = 0 -- Startup things
	self.Speed = 20
	self.Heat = 0
	self.Cooler = false

	self.LvlExp = 100

	if self.CrclCfg.MaxMoney then self.MaxMoney = self.CrclCfg.MaxMoney end
	if self.CrclCfg.PrintRate then self.PlusMoney = self.CrclCfg.PrintRate end
	if self.CrclCfg.PrintInterval then self.PrintRate = self.CrclCfg.PrintInterval end
	if self.CrclCfg.PlusSpeed then self.PlusSpeed = self.CrclCfg.PlusSpeed end
	if self.CrclCfg.SpeedUpgradePrice then self.SpeedPrice = self.CrclCfg.SpeedUpgradePrice end
	if self.CrclCfg.CoolingUpgradePrice then self.CoolerPrice = self.CrclCfg.CoolingUpgradePrice end

	timer.Simple(1, function() 
		if IsValid(self) then 
			self.NextPrint = CurTime() + self.PrintRate
			UpdateCircleClientSide(self)
		end 
	end)
	timer.Simple(self.PrintRate, function() if IsValid(self) then self:Work() end end)
end

function ENT:AddMoney( amnt )
	if IsValid(self) then
		if self.Money < self.MaxMoney then
			self.Money = self.Money + (self.Speed/100*amnt)
			if self.Money > self.MaxMoney then
				self.Money = self.MaxMoney
			end
		end
	end
end

function ENT:Upgrade( item )
	if IsValid(self) then
		if item == "cooler" and self.Cooler == false then
			self.Cooler = true
		elseif item == "speed" and self.Speed < 100 then
			self.Speed = self.Speed + 20
		end
	end
end

function ENT:Destruct()
	if IsValid(self:Getowning_ent()) then
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("Explosion", effectdata)
		DarkRP.notify(self:Getowning_ent(), 1, 4, "Your money printer exploded")
	end
end

function ENT:OnTakeDamage(dmg)
	if self:IsOnFire() then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		self:Destruct()
		self:Remove()
	end
end

function ENT:Think()
	if not IsValid(self:Getowning_ent()) then
		self:Destruct()
		self:Remove()
	end

	if self.Working then return end
	local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(1)
    effectdata:SetRadius(2)
    util.Effect("Sparks", effectdata)
end

function ENT:HeatControll()
	if IsValid(self) then
		if self.Cooler then
			if self.Heat < 90 and self.Speed > 40 then
				self.Heat = self.Heat + 10
			else
				if self.Heat > 0 then
					self.Heat = self.Heat - 10
				end
			end
		else
			if self.Speed > 50 then
				self.Heat = self.Heat + 10
			else
				if self.Heat <= 50 then
					self.Heat = self.Heat + 10
				else
					self.Heat = self.Heat - 10
				end
			end
		end
		if self.Heat >= 100 then
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:BreakControll()
	if math.random(1, self.CrclCfg.FireUpChance) == 3 then
		self.Working = false
		DarkRP.notify( self:Getowning_ent(), 1, 5, "Your money printer is broken go fix it!")
	end
end


function ENT:Work()
	if IsValid(self) then
		if self.Working then
			self:AddMoney(self.PlusMoney + (math.floor(self.LvlExp/100)*self.PlusMoney/4))
			self.NextPrint = CurTime() + self.PrintRate
			self:HeatControll()
			if self.CrclCfg.OnPrintFunc and IsValid(self:Getowning_ent()) then
				self.CrclCfg.OnPrintFunc(self:Getowning_ent())
			end
			self:BreakControll()
			if self.LvlExp < 900 then
				self.LvlExp = self.LvlExp + 10 -- !
			end
		end
		UpdateCircleClientSide(self)
		timer.Simple(self.PrintRate, function() if IsValid(self) then self:Work() end end)
	end
end

local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
    local vWorldPos=vWorldPos-vPos
    vWorldPos:Rotate(Angle(0,-aRot.y,0))
    vWorldPos:Rotate(Angle(-aRot.p,0,0))
    vWorldPos:Rotate(Angle(0,0,-aRot.r))
    return vWorldPos.x/vScale,(-vWorldPos.y)/vScale
end

local function inrange(x, y, x2, y2, x3, y3)
	if x > x3 then return false end
	if y < y3 then return false end
	if x2 < x3 then return false end
	if y2 > y3 then return false end
	return true
end

function ENT:Use(ply)
	if self.CrclCfg.PreventWireUsers then
		self.trac = util.TraceLine( util.GetPlayerTrace( ply ) )
		self.players = ents.FindInSphere( self:GetPos(), 50 )
		for _, v in pairs(self.players) do
			if v == ply and self.trac.Entity == self then
				self.PlayerPressedE = true
				break
			else
				self.PlayerPressedE = false
			end
		end
	end
	if ply:IsPlayer() and self.PlayerPressedE then
		self.Working = true
		local lookAtX,lookAtY = WorldToScreen(ply:GetEyeTrace().HitPos or Vector(0,0,0),self:GetPos()+self:GetAngles():Up()*1.55, 0.2375, self:GetAngles())
		if inrange(44.45, -36.06, 51.41, -63.11, lookAtX, lookAtY) and ply:getDarkRPVar("money") >= self.SpeedPrice and self.Speed < 100 then
			sound.Play( "buttons/button15.wav", self:GetPos(), 100, 100, 1 )
			ply:addMoney( -self.SpeedPrice )
			DarkRP.notify( ply, 2, 5, "Printer speed has been upgraded!" )
			self.Speed = self.Speed + self.PlusSpeed
			UpdateCircleClientSide(self)
		elseif inrange(52.80, -36.06, 59.69, -63.11, lookAtX, lookAtY) and ply:getDarkRPVar("money") >= self.CoolerPrice and self.Cooler == false then
			sound.Play( "buttons/button15.wav", self:GetPos(), 100, 100, 1 )
			ply:addMoney( -self.CoolerPrice )
			DarkRP.notify( ply, 2, 5, "Printer cooler has been added!" )
			self.Cooler = true
			UpdateCircleClientSide(self)
		elseif self.Money > 0 then
			ply:addMoney( self.Money )
			DarkRP.notify( ply, 0, 5, "You picked up $"..self.Money )
			self.Money = 0
			UpdateCircleClientSide(self)
		end
    end
end

function ENT:UClSide()
	if IsValid(self) then
		UpdateCircleClientSide(self)
	end
end