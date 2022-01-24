local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "RPName Changes"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("onPlayerChangedName","changename",function(ply,before,after)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " changed name from " .. bLogs:Highlight(bLogs:Escape(before)) .. " to " .. bLogs:Highlight(bLogs:Escape(after)))
end)

bLogs:AddModule(MODULE)
