local MODULE = bLogs:Module()

MODULE.Category = "TTT"
MODULE.Name     = "Bodies"
MODULE.Colour   = Color(255,130,0)

MODULE:Hook("TTTBodyFound","tttbody",function(ply,deadply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " found the body of " .. bLogs:FormatPlayer(deadply))
end)

bLogs:AddModule(MODULE)
