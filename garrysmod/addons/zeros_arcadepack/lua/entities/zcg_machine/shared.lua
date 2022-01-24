ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "CoinPusher"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros ArcadePack"
ENT.Model = "models/zerochain/props_arcade/zap_coinpusher.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "MoneyCount")

	if (SERVER) then
		self:SetMoneyCount(0)
	end
end
