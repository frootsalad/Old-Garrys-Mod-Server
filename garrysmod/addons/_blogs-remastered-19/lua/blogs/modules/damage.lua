local MODULE = bLogs:Module()

MODULE.Category = "Player Events"
MODULE.Name     = "Damage"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("EntityTakeDamage","damagelog",function(ply,dmginfo)
	if (not IsValid(ply)) then return end
	if (not ply:IsPlayer()) then return end
	if (GetConVar("sbox_godmode"):GetInt() == 1) then return end
	if (ply:HasGodMode()) then return end

	local weapon
	local with_a = ""

	local attacker

	local damage = math.ceil(dmginfo:GetDamage())
	if (damage < 1) then return end

	if (IsValid(dmginfo:GetAttacker())) then
		if (not dmginfo:GetAttacker():IsWorld()) then
			if (dmginfo:GetAttacker():GetClass() == "prop_physics") then
				return
			end
			attacker = dmginfo:GetAttacker()
			if (attacker == ply) then
				weapon = attacker:GetActiveWeapon()
				attacker = "themself"
				with_a = " with a " .. bLogs:FormatEntity(weapon)
			else
				if (attacker:IsNPC() or attacker:IsPlayer()) then
					if (IsValid(attacker:GetActiveWeapon())) then
						weapon = attacker:GetActiveWeapon()
						with_a = " with a " .. bLogs:FormatEntity(weapon)
					end
				end
				if (attacker:IsPlayer()) then
					attacker = bLogs:FormatPlayer(attacker)
				elseif (attacker:IsVehicle()) then
					attacker = bLogs:FormatVehicle(attacker)
				elseif (attacker:GetTable()) then
					attacker = bLogs:FormatEntity(attacker)
				end
			end
		end
	end

	if (dmginfo:IsDamageType(DMG_BULLET)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was shot for " .. bLogs:Highlight(damage) .. " damage by " .. bLogs:FormatPlayer(dmginfo:GetAttacker()) .. with_a)
	elseif (dmginfo:IsDamageType(DMG_BUCKSHOT)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was shotgunned for " .. bLogs:Highlight(damage) .. " damage by " .. bLogs:FormatPlayer(dmginfo:GetAttacker()) .. with_a)
	elseif (dmginfo:IsDamageType(DMG_FALL)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " took " .. bLogs:Highlight(damage) .. " falldamage")
	elseif (dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_BLAST_SURFACE)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " took " .. bLogs:Highlight(damage) .. " damage from an explosion")
	elseif (dmginfo:IsDamageType(DMG_CRUSH)) then
		if (attacker) then
			if (attacker == ply and attacker:InVehicle()) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " was hit a wall with their car and succumbed to " .. bLogs:Highlight(damage) .. " damage")
			else
				MODULE:Log(bLogs:FormatPlayer(ply) .. " was crushed for " .. bLogs:Highlight(damage) .. " damage by " .. attacker)
			end
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was crushed for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_SLASH)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was slashed for " .. bLogs:Highlight(damage) .. " damage by " .. attacker)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was slashed for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_SLOWBURN)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was burnt for " .. bLogs:Highlight(damage) .. " damage")
	elseif (dmginfo:IsDamageType(DMG_CLUB)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was clubbed for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was clubbed for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_SHOCK)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was electrically shocked for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was electrically shocked for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_DROWN)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " drowned for " .. bLogs:Highlight(damage) .. " damage")
	elseif (dmginfo:IsDamageType(DMG_SONIC)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was sonic boomed for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was sonic boomed for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_ENERGYBEAM)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was lasered for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was lasered for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_NERVEGAS)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was nerve gassed for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was nerve gassed for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_POISON) or dmginfo:IsDamageType(DMG_PARALYZE)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was poisoned for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was poisoned for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_ACID)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was acid burned for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was acid burned for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_DISSOLVE)) then
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was dissolved for " .. bLogs:Highlight(damage) .. " damage by " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was dissolved for " .. bLogs:Highlight(damage) .. " damage")
		end
	elseif (dmginfo:IsDamageType(DMG_RADIATION)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was irradiated for " .. bLogs:Highlight(damage) .. " damage")
	elseif (dmginfo:IsDamageType(DMG_RADIATION)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was irradiated for " .. bLogs:Highlight(damage) .. " damage")
	elseif (dmginfo:IsDamageType(DMG_PLASMA)) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was damaged by plasma for " .. bLogs:Highlight(damage) .. " damage")
	elseif (dmginfo:IsDamageType(DMG_VEHICLE)) then
		if (not dmginfo:GetAttacker():IsVehicle()) then return end
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was hit by a " .. attacker)
	else
		if (attacker) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " took " .. bLogs:Highlight(damage) .. " damage from " .. attacker .. with_a)
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " took " .. bLogs:Highlight(damage) .. " damage")
		end
	end
end)

bLogs:AddModule(MODULE)


-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Player Events"
MODULE.Name     = "Vehicle Damage"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("EntityTakeDamage","vehicledmglog",function(vehicle,dmginfo)
	if (not IsValid(vehicle)) then return end
	if (not vehicle:IsVehicle()) then return end

	local weapon
	local with_a = ""

	local attacker

	local damage = math.ceil(dmginfo:GetDamage())
	if (damage < 1) then return end

	if (IsValid(dmginfo:GetAttacker())) then
		if (dmginfo:GetAttacker():IsWorld()) then return end
		if (not dmginfo:GetAttacker():IsPlayer()) then return end
		attacker = dmginfo:GetAttacker()
		if (IsValid(attacker:GetActiveWeapon())) then
			weapon = attacker:GetActiveWeapon()
			with_a = " with a " .. bLogs:FormatEntity(weapon)
		end
		attacker = bLogs:FormatPlayer(attacker)
	else
		return
	end

	MODULE:Log(attacker .. " damaged " .. bLogs:FormatVehicle(vehicle) .. " for " .. bLogs:Highlight(damage) .. " damage" .. with_a)
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Player Events"
MODULE.Name     = "Deaths"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("PlayerDeath","deathlog",function(ply,inflictor,attacker)
	if (attacker:IsWorld()) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " died from falldamage")
		return
	end

	if (attacker:GetClass() == "prop_physics") then return end

	if (ply == attacker) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " killed themselves")
	else
		if (attacker:IsNPC() or attacker:IsPlayer()) then
			local weapon = attacker:GetActiveWeapon()
			local with_a = ""
			if (IsValid(weapon)) then
				weapon = bLogs:FormatEntity(weapon)
				with_a = " with a " .. weapon
			end
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was killed by " .. bLogs:FormatPlayer(attacker) .. with_a)
		elseif (attacker:IsVehicle()) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was killed by " .. bLogs:FormatVehicle(attacker))
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was killed by " .. bLogs:FormatEntity(attacker))
		end
	end
end)

bLogs:AddModule(MODULE)