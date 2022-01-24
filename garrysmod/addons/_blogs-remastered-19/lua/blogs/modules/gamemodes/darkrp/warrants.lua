local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Warrants"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerWarranted","warrant",function(criminal,actor,reason)
	MODULE:Log(bLogs:FormatPlayer(actor) .. " filed a warrant on " .. bLogs:FormatPlayer(criminal) .. " for: " .. bLogs:Highlight(bLogs:Escape(reason)))
end)

MODULE:Hook("playerWarranted","unwarrant",function(excriminal,actor)
	MODULE:Log(bLogs:FormatPlayer(actor) .. " cancelled a warrant on " .. bLogs:FormatPlayer(excriminal))
end)

bLogs:AddModule(MODULE)
