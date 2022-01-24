if (DarkRP.disabledDefaults.modules.hitmenu) then return end

local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Hits"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("onHitAccepted","hitaccepted",function(hitman,target,customer)
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " has accepted the hit on " .. bLogs:FormatPlayer(target) .. " requested by " .. bLogs:FormatPlayer(customer))
end)

MODULE:Hook("onHitCompleted","hitcompleted",function(hitman,target,customer)
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " has completed the hit on " .. bLogs:FormatPlayer(target) .. " requested by " .. bLogs:FormatPlayer(customer))
end)

MODULE:Hook("onHitFailed","hitfailed",function(hitman,target,customer)
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " has failed the hit on " .. bLogs:FormatPlayer(target) .. " requested by " .. bLogs:FormatPlayer(customer))
end)

MODULE:Hook("canRequestHit","hitrequested",function(hitman,target,customer,price)
	MODULE:Log(bLogs:FormatPlayer(customer) .. " has requested a hit on " .. bLogs:FormatPlayer(target) .. " with " .. bLogs:FormatPlayer(hitman) .. " for " .. bLogs:FormatMoney(price))
end,2)

bLogs:AddModule(MODULE)
