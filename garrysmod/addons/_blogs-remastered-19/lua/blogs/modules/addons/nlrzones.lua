if (not nlr) then return end

local MODULE = bLogs:Module()

MODULE.Category = "NLR Zones"
MODULE.Name     = "NLR Zone Entered"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("PlayerEnteredNlrZone","nlrentered",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " entered an NLR zone")
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "NLR Zones"
MODULE.Name     = "NLR Zone Exited"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("PlayerExitedNlrZone","nlrexit",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " exited an NLR zone")
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "NLR Zones"
MODULE.Name     = "NLR Breaking"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("PlayerBreakNLR","nlrbreak",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " broke NLR!")
end)

bLogs:AddModule(MODULE)
