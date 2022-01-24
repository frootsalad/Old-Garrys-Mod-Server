if (not hhh) then return end

local MODULE = bLogs:Module()

MODULE.Category = "HHH"
MODULE.Name     = "Hit Aborted"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("hhh_hitAborted","hhh_hitaborted",function(hitinfo)
	if (hitinfo == nil) then return end
	if (not IsValid(hitinfo.target)) then return end
	MODULE:Log("The hit placed by " .. bLogs:FormatPlayer(hitinfo.requester) .. " on " .. bLogs:FormatPlayer(hitinfo.target) .. " was aborted")
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "HHH"
MODULE.Name     = "Hit Completed"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("hhh_hitFinished","hhh_hitsuccess",function(hitman,target)
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " successfully completed their hit on " .. bLogs:FormatPlayer(target))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "HHH"
MODULE.Name     = "Hit Requested"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("hhh_hitRequested","hhh_hitrequested",function(hitinfo)
	MODULE:Log(bLogs:FormatPlayer(hitinfo.requester) .. " requested a " .. bLogs:FormatCurrency(hitinfo.reward) .. " hit on " .. bLogs:FormatPlayer(hitinfo.target))
end)

bLogs:AddModule(MODULE)
