ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Filter"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros Meth Lab"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsInstalled")
end
