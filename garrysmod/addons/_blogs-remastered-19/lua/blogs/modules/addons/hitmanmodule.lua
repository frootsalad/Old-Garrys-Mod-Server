if (not HitModule) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Hitman Module"
MODULE.Name     = "Hit Failed"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("HMHitmanKilled","hm_hitfailed",function(victim,hitman,reward)
	if (not IsValid(victim)) then return end
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " failed their " .. bLogs:FormatCurrency(reward) .. " hit on " .. bLogs:FormatPlayer(victim))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Hitman Module"
MODULE.Name     = "Hit Completed"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("HMHitComplete","hm_hitsuccess",function(victim,hitman,reward)
	if (not IsValid(victim)) then return end
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " successfully completed their " .. bLogs:FormatCurrency(reward) .. " hit on " .. bLogs:FormatPlayer(victim))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Hitman Module"
MODULE.Name     = "Hit Accepted"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("HMHitAccepted","hm_hitaccepted",function(victim,hitman,reward)
	if (not IsValid(victim)) then return end
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " accepted a " .. bLogs:FormatCurrency(reward) .. " hit on " .. bLogs:FormatPlayer(victim))
end)

bLogs:AddModule(MODULE)
