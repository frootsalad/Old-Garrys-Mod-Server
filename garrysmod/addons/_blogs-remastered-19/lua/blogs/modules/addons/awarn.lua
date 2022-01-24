if (not AWarn) then return end

local MODULE = bLogs:Module()

MODULE.Category = "AWarn"
MODULE.Name     = "Warnings"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("AWarnPlayerWarned","warned",function(ply,admin,reason)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " was warned by " .. bLogs:FormatPlayer(admin) .. " for " .. bLogs:Highlight(bLogs:Highlight(bLogs:Escape(reason))))
end)

MODULE:Hook("AWarnPlayerIDWarned","idwarned",function(steamid,admin,reason)
	MODULE:Log(bLogs:FormatPlayer(steamid) .. " was warned by " .. bLogs:FormatPlayer(admin) .. " for " .. bLogs:Highlight(bLogs:Highlight(bLogs:Escape(reason))))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "AWarn"
MODULE.Name     = "Kicks"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("AWarnLimitKick","warnkick",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " was {#H|kicked|#} for reaching the active warning threshold.")
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "AWarn"
MODULE.Name     = "Bans"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("AWarnLimitBan","warnban",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " was {#H|banned|#} for reaching the active warning threshold.")
end)

bLogs:AddModule(MODULE)
