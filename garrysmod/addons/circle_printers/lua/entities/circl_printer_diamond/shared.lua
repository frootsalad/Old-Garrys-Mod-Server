/*---------------------------------------------------------------------------
Tomas
---------------------------------------------------------------------------*/
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "Tomas"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")

	self.CrclCfg = {}--Keep this

	self.CrclCfg.Name = "Diamond Printer" -- The name of the printer...
	self.CrclCfg.FireUpChance = 50 -- Printer break chance
	self.CrclCfg.MaxMoney = 30000 -- Max money that it can hold
	self.CrclCfg.PrintInterval = 10 -- Interval in sec that it prints
	self.CrclCfg.PrintRate = 750 -- Prints this amount of the money if it have 100% upgraded speed + exp money added to this 1lvl = 1/4 of this number
	self.CrclCfg.SpeedUpgradePrice = 10000 -- Price for the speed upgrade
	self.CrclCfg.CoolingUpgradePrice = 75000 -- Price for the cooling upgrade
	self.CrclCfg.PlusSpeed = 20 -- If you push upgrade speed it will upgrade that much
	self.CrclCfg.ModelColor = Color(6, 21, 21, 255) -- Printer main model color
	self.CrclCfg.ComputerPartColor = Color(255, 255, 255, 255) -- Printer front computer part color
	self.CrclCfg.FanCaseColor = Color(27, 27, 27, 255) -- Printer front Fan case color
	self.CrclCfg.FanColor = Color(166, 166, 166, 255) -- Printer front Fan color
	self.CrclCfg.ModelMaterial = "models/debug/debugwhite" -- Printer main model material. Type "nomat" for no material
	self.CrclCfg.ComputerPartMaterial = "nomat" -- Printer front computer part material. Type "nomat" for no material
	self.CrclCfg.FanCaseMaterial = "models/debug/debugwhite" -- Printer front Fan case material. Type "nomat" for no material
	self.CrclCfg.FanMaterial = "models/debug/debugwhite" -- Printer front Fan material. Type "nomat" for no material
	self.CrclCfg.OnPrintFunc = function(ply) end -- Printer call this function onPrint so its useful for xp, lvl systems or anything You want +
	self.CrclCfg.PreventWireUsers = false -- It does that what variable name says (Limits use distance to 100 and checks if player is looking at entity)
		customCheck = function(ply) return ply:CheckGroup("donator", "vip", "celestial") end
	CustomCheckFailMsg = "This is a donator+ printer."
end