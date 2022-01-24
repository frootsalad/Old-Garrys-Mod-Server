if (DarkRP.disabledDefaults.modules.hungermod) then return end

local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Starvation"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerStarved","starved",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " starved")
end)

bLogs:AddModule(MODULE)
