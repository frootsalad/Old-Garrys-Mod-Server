local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Laws"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("bLogs_addLaw","addlaw",function(ply,law)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " added law: " .. bLogs:Escape(law))
end)
MODULE:Hook("bLogs_removeLaw","removeLaw",function(ply,law)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " removed law: " .. bLogs:Escape(law))
end)

bLogs:AddModule(MODULE)
