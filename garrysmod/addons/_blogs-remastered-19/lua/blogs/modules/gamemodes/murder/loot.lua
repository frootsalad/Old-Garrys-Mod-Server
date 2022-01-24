local MODULE = bLogs:Module()

MODULE.Category = "Murder"
MODULE.Name     = "Loot"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("PlayerPickupLoot","pickuploot",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " picked up loot")
end)

bLogs:AddModule(MODULE)
