if (not wck) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Extras"
MODULE.Name     = "Wyozi Cinema"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("WCKVideoQueued","WCK",function(queuetable)
	MODULE:Log(bLogs:FormatPlayer(queuetable.player) .. " requested video " .. bLogs:Highlight(queuetable.video_title) .. " (" .. bLogs:Highlight(queuetable.video_url) .. ") at cinema " .. bLogs:Highlight(queuetable.cinema))
end)

bLogs:AddModule(MODULE)
