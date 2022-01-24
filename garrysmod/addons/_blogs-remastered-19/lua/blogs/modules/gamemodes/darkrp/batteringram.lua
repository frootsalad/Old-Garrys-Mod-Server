local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Battering Ram"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("onDoorRamUsed","batteringram",function(success,ply,trace)
	local door = trace.Entity
	if (success) then
		if (IsValid(door:getDoorOwner())) then
			if (door:IsVehicle()) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully battering rammed the " .. bLogs:FormatEntity(door) .. " of " .. bLogs:FormatPlayer(ply))
			else
				MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully battering rammed the door of " .. bLogs:FormatPlayer(ply))
			end
		else
			if (door:IsVehicle()) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully battering rammed an unowned " .. bLogs:FormatEntity(door))
			else
				MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully battering rammed an unowned door")
			end
		end
	else
		if (IsValid(door:getDoorOwner())) then
			if (door:IsVehicle()) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to battering ram the " .. bLogs:FormatEntity(door) .. " of " .. bLogs:FormatPlayer(ply))
			else
				MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to battering ram the door of " .. bLogs:FormatPlayer(ply))
			end
		else
			if (door:IsVehicle()) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to battering ram an unowned " .. bLogs:FormatEntity(door))
			else
				MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to battering ram an unowned door")
			end
		end
	end
end)

bLogs:AddModule(MODULE)
