if (not ConVarExists("cuffs_allowbreakout")) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Cuffs"
MODULE.Name     = "Handcuffs"
MODULE.Colour   = Color(255,130,0)

MODULE:Hook("OnHandcuffed","handcuffed",function(cuffer,cuffed)
	MODULE:Log(bLogs:FormatPlayer(cuffer) .. " handcuffed " .. bLogs:FormatPlayer(cuffed))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Cuffs"
MODULE.Name     = "Cuff Breaks"
MODULE.Colour   = Color(255,130,0)

MODULE:Hook("OnHandcuffBreak","cuffbreaks",function(cuffed,_,mate)
	if (IsValid(mate)) then
		MODULE:Log(bLogs:FormatPlayer(mate) .. " broke " .. bLogs:FormatPlayer(cuffed) .. " out of handcuffs")
	else
		MODULE:Log(bLogs:FormatPlayer(cuffed) .. " broke out of handcuffs")
	end
end)

bLogs:AddModule(MODULE)
