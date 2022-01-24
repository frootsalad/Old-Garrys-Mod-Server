local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Arrests"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerArrested","arrested",function(criminal,time,actor)
	MODULE:Log(bLogs:FormatPlayer(actor) .. " arrested " .. bLogs:FormatPlayer(criminal))
end)

MODULE:Hook("playerUnArrested","unarrested",function(excriminal,actor)
	MODULE:Log(bLogs:FormatPlayer(actor) .. " released " .. bLogs:FormatPlayer(excriminal))
end)

bLogs:AddModule(MODULE)
