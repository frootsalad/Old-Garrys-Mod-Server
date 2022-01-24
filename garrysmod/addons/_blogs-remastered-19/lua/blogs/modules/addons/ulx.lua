if (not ulx or not ULib) then return end

local MODULE = bLogs:Module()

MODULE.Category = "ULX"
MODULE.Name     = "Commands"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook(ULib.HOOK_COMMAND_CALLED,"ulib_cmd_called",function(ply,cmd,args)
	if (bLogs.Config.BlacklistedCommands) then
		if (bLogs.Config.BlacklistedCommands.ulx) then
			if (table.HasValue(bLogs.Config.BlacklistedCommands.ulx,cmd)) then return end
		end
	end
	MODULE:Log(bLogs:FormatPlayer(ply) .. ": " .. (string.gsub(cmd .. " " .. table.concat(args," ")," $","")))
end)

bLogs:AddModule(MODULE)
