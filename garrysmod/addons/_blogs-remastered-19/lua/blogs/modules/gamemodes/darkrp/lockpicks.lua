local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Lockpicking"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("lockpickStarted","lockpick_started",function(ply,ent)
	if (IsValid(ent:getDoorOwner())) then
		if (ent:IsVehicle()) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " started lockpicking the " .. bLogs:FormatEntity(ent) .. " of " .. bLogs:FormatPlayer(ent:getDoorOwner()))
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " started lockpicking the door of " .. bLogs:FormatPlayer(ent:getDoorOwner()))
		end
	else
		if (ent:IsVehicle()) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " started lockpicking an unowned " .. bLogs:FormatEntity(ent))
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " started lockpicking an unowned door")
		end
	end
end)

MODULE:Hook("onLockpickCompleted","lockpick_started",function(ply,success,ent)
	if (success) then
		if (IsValid(ent:getDoorOwner())) then
			if (ent:getDoorOwner() == ply) then
				if (ent:IsVehicle()) then
					MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully lockpicked their own " .. bLogs:FormatEntity(ent))
				else
					MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully lockpicked their own door")
				end
			else
				if (ent:IsVehicle()) then
					MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully lockpicked the " .. bLogs:FormatEntity(ent) .. " of " .. bLogs:FormatPlayer(ent:getDoorOwner()))
				else
					MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully lockpicked the door of " .. bLogs:FormatPlayer(ent:getDoorOwner()))
				end
			end
		else
			if (ent:IsVehicle()) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully lockpicked an unowned " .. bLogs:FormatEntity(ent))
			else
				MODULE:Log(bLogs:FormatPlayer(ply) .. " successfully lockpicked an unowned door")
			end
		end
	else
		if (IsValid(ent:getDoorOwner())) then
			if (ent:getDoorOwner() == ply) then
				if (ent:IsVehicle()) then
					MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to lockpick their own " .. bLogs:FormatEntity(ent))
				else
					MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to lockpick their own door")
				end
			else
				if (ent:IsVehicle()) then
					MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to lockpick the " .. bLogs:FormatEntity(ent) .. " of " .. bLogs:FormatPlayer(ent:getDoorOwner()))
				else
					MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to lockpick the door of " .. bLogs:FormatPlayer(ent:getDoorOwner()))
				end
			end
		else
			if (ent:IsVehicle()) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to lockpick an unowned " .. bLogs:FormatEntity(ent))
			else
				MODULE:Log(bLogs:FormatPlayer(ply) .. " failed to lockpick an unowned door")
			end
		end
	end
end)

bLogs:AddModule(MODULE)
