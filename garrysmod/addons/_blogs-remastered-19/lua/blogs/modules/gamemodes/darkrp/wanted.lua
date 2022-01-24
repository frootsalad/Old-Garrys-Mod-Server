local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Wanted"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerWanted","wanted",function(criminal,actor,reason)
	MODULE:Log(bLogs:FormatPlayer(actor) .. " set " .. bLogs:FormatPlayer(criminal) .. " as wanted for: " .. bLogs:Highlight(bLogs:Escape(reason)))
end)

MODULE:Hook("playerUnWanted","unwanted",function(excriminal,actor)
	MODULE:Log(bLogs:FormatPlayer(actor) .. " cancelled the wanted status of " .. bLogs:FormatPlayer(excriminal))
end)

bLogs:AddModule(MODULE)
