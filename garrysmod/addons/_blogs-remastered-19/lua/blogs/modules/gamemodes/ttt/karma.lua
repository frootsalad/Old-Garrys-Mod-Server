local MODULE = bLogs:Module()

MODULE.Category = "TTT"
MODULE.Name     = "Karma Kicking"
MODULE.Colour   = Color(255,130,0)

MODULE:Hook("TTTKarmaLow","karmakick",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " was {#H|kicked|} for having too low karma")
end,2)

bLogs:AddModule(MODULE)
