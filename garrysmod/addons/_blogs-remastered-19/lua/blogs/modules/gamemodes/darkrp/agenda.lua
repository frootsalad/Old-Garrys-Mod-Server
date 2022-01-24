local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Agendas"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("agendaUpdated","agendaUpdated",function(ply,agenda,text)
	if (text == "" and ply == nil) then return end
	MODULE:Log(bLogs:FormatPlayer(ply) .. " updated the " .. bLogs:Highlight(agenda.Title) .. " agenda to: " .. bLogs:Escape(text))
end)
MODULE:Hook("onAgendaRemoved","onAgendaRemoved",function(ply,agenda)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " removed the " .. bLogs:Highlight(agenda.Title) .. " agenda")
end)

bLogs:AddModule(MODULE)