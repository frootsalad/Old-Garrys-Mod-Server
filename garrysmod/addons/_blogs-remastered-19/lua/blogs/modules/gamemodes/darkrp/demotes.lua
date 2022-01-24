local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Demotes"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("onPlayerDemoted","demoted",function(ply,target,reason)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " demoted " .. bLogs:FormatPlayer(target) .. " for " .. bLogs:Highlight(bLogs:Escape(reason)))
end)

if (DarkRP.disabledDefaults.modules.afk == false) then
	MODULE:Hook("playerAFKDemoted","afkdemoted",function(ply)
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was demoted for being AFK")
	end)
end

bLogs:AddModule(MODULE)
