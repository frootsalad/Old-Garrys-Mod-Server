local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Pocket"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("onPocketItemAdded","pocketadded",function(ply,ent)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " put a " .. bLogs:FormatEntity(ent) .. " in their pocket")
end)

MODULE:Hook("onPocketItemDropped","pocketdropped",function(ply,ent)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " dropped a " .. bLogs:FormatEntity(ent) .. " from their pocket")
end)

bLogs:AddModule(MODULE)
