local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Adverts"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerAdverted","advert",function(ply,arg)
	MODULE:Log(bLogs:FormatPlayer(ply) .. ": " .. bLogs:Escape(arg))
end)

bLogs:AddModule(MODULE)
