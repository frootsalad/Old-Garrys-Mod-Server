ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Category       = "MGangs 2"
ENT.PrintName		   = "MGangs 2 - Territory Flag"
ENT.Author			   = "Zephruz & ZeroChain"
ENT.Contact			   = "https://zephruz.net/"
ENT.Purpose			   = "Identify a Territory"
ENT.Instructions	 = "Used to identify a territory that can be captured."
ENT.Spawnable		    =  true
ENT.AdminSpawnable	=  false
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	-- Ents
	self:NetworkVar("Entity", 0, "ClaimingPly")

  -- Ints
	self:NetworkVar("Int", 0, "GangID")
  self:NetworkVar("Int", 1, "CaptureTime")
	self:NetworkVar("Int", 2, "TerritoryID")
	self:NetworkVar("Int", 3, "ClaimStart")
end
