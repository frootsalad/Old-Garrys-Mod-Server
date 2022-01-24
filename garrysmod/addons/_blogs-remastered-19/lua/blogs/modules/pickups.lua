local MODULE = bLogs:Module()

MODULE.Category = "Player Events"
MODULE.Name     = "Pickups"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("PlayerDeath","player_died_prevent_logging",function(ply)
	ply.bLogs_Do_Not_Log_Pickups = true
end)
MODULE:Hook("PlayerInitialSpawn","player_spawning_prevent_logging",function(ply)
	ply.bLogs_Do_Not_Log_Pickups = true
end)

MODULE:Hook("PlayerCanPickupWeapon","pickupweapon",function(ply,wep)
	if (ply.bLogs_Do_Not_Log_Pickups) then return end
	MODULE:Log(bLogs:FormatPlayer(ply) .. " picked up " .. bLogs:FormatEntity(wep))
end,2)

MODULE:Hook("PlayerCanPickupItem","pickupitem",function(ply,item)
	if (ply.bLogs_Do_Not_Log_Pickups) then return end
	MODULE:Log(bLogs:FormatPlayer(ply) .. " picked up " .. bLogs:FormatEntity(item))
end,2)

MODULE:Hook("PlayerSpawn","player_spawned_allow_logging",function(ply)
	timer.Simple(5,function()
		if (not IsValid(ply)) then return end
		ply.bLogs_Do_Not_Log_Pickups = nil
	end)
end)

bLogs:AddModule(MODULE)
