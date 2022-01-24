if (not serverguard) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Serverguard"
MODULE.Name     = "Commands"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("serverguard.RanCommand", "blogs_serverguard.RanCommand", function(player, commandTable, bSilent, arguments)
	MODULE:Log(bLogs:FormatPlayer(player) .. " ran command " .. bLogs:Escape(commandTable.command) .. " " .. table.concat(arguments, " "))
end)

bLogs:AddModule(MODULE)