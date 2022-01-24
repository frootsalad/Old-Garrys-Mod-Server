local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Doors"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerSellDoor","solddoor",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " sold a door")
end,2)

MODULE:Hook("playerBoughtDoor","boughtdoor",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought a door")
end,2)

bLogs:AddModule(MODULE)
