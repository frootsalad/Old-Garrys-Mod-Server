local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Job Changes"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("OnPlayerChangedTeam","changejob",function(ply,before,after)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " changed from " .. bLogs:Highlight(team.GetName(before)) .. " to " .. bLogs:Highlight(team.GetName(after)))
end)

bLogs:AddModule(MODULE)
