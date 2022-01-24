//
/*
	Server Entrypoint
	3/2/2018
	Smart Like My Shoe 
*/


/*
	Pooled Strings
*/
util.AddNetworkString("smartsauce_menu");
util.AddNetworkString("smartsauce_edit");
util.AddNetworkString("smartsauce_decal");

/*
	Main
*/

local main = {};

main.physgunGhostList = {}; // stores all entity classes that should be ghosted on pickup
main.physgunGhostList["prop_physics"] = true;

main.fadingDoorTools = {};
main.fadingDoorTools["fading_door"] = true;
main.fadingDoorTools["fadingdoor"] = true;
main.fadingDoorTools["fadingdoor2"] = true;
main.fadingDoorTools["fading_door2"] = true;
main.fadingDoorTools["fading"] = true;


main.antiSpamIgnore  = {};
main.antiSpamIgnore["advdupe2"] = true;
main.antiSpamIgnore["advdupe"] = true;
main.antiSpamIgnore["duplicator"] = true;

main.propsInPropsIgnore = {};
main.propsInPropsIgnore["stacker_improved"] = true;
main.propsInPropsIgnore["stacker"] = true;
main.propsInPropsIgnore["advdupe2"] = true;
main.propsInPropsIgnore["advdupe"] = true;
main.propsInPropsIgnore["duplicator"] = true;


main.ghostData = {}; // stores entity information such as original color, etc
main.ghostZones = {}; // stores zone information such as position, mins, maxs, etc

main.cleanupThreshold 	= smartsauce_config.defaultCleanupThreshold;
main.unfreezeThreshold 	= smartsauce_config.defaultUnfreezeThreshold;
main.fadingDoorThreshold = smartsauce_config.defaultFadingDoorThreshold;
main.bGhostProps 		= true;
main.bPropDamage 		= false;
main.bAntiCrash  		= true;
main.bNoCollide	 		= true;
main.bVehicleDamage 	= true;
main.bGravgunPunt		= true;
main.bDecalClean		= true;
main.bPhysgunUnfreeze 	= true;
main.bAntiSpam 			= true;
main.bPropsInProps		= true;
main.bGhostGravGun 		= true;
main.bInVehicleDamage	= true;

/*
	Micro Optimizations
*/
local ents = ents;

/*
	Plugins 
*/
local propertiesPlugin = include("plugins/sh_properties.lua");
local lag = include("plugins/sv_lagdetector.lua");
local notify = include("plugins/sh_notify.lua");
include("plugins/sv_advdupe.lua");

/*	
	Generates the variable table 
*/
function main:GenerateVariableTable()

	return {
		physgunGhostList = self.physgunGhostList,
		ghostZones = self.ghostZones,
		bGhostProps = self.bGhostProps,
		bPropDamage = self.bPropDamage,
		bAntiCrash = self.bAntiCrash,
		bNoCollide = self.bNoCollide,
		bVehicleDamage = self.bVehicleDamage,
		cleanupThreshold = self.cleanupThreshold,
		unfreezeThreshold = self.unfreezeThreshold,
		bGravgunPunt = self.bGravgunPunt,
		bDecalClean = self.bDecalClean,
		bPhysgunUnfreeze = self.bPhysgunUnfreeze,
		bAntiSpam = self.bAntiSpam,
		bPropsInProps = self.bPropsInProps,
		bGhostGravGun = self.bGhostGravGun,
		bInVehicleDamage = self.bInVehicleDamage,
		fadingDoorThreshold = self.fadingDoorThreshold,
	};
end

/*
	Saves all data 
*/
function main:Save()
	
	file.Write(smartsauce_config.fileName, util.TableToJSON(self:GenerateVariableTable()));
end 

/*
	Loads all data 
*/
function main:Load()
	
	if (file.Exists(smartsauce_config.fileName, "DATA")) then 
	
		local data = util.JSONToTable(file.Read(smartsauce_config.fileName, "DATA"));
		if (data == nil) then return end 
		
		for k,v in next, data do 
			main[k] = v;
		end 
	end
end 

/*
	Returns a bool if the player is staff 
*/
function main:IsStaff(ply)

	if (ply.GetUserGroup == nil) then return ply:IsAdmin() end 
	if (smartsauce_config.staff[ply:GetUserGroup()]) then return true else return false end
end

/*
	Handles ghosting of entities 
*/

function main:GhostEntity(ent)

	if (self.ghostData[ent:EntIndex()]) then return end
	
	self.ghostData[ent:EntIndex()] = {
		color = ent:GetColor(),
		collisionGroup = ent:GetCollisionGroup(),
		renderMode	= ent:GetRenderMode(),
	};
	
	ent:SetRenderMode(RENDERMODE_TRANSALPHA);
	ent:SetColor(smartsauce_config.ghostColor);
	
	if (self.bNoCollide) then 
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD);
	else 
		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
	end
end 
hook.Add("smartsauce_ghostentity", "ghostentity", function(ent)
	main:GhostEntity(ent);
end);

function main:UnghostEntity(ent)

	local originalData = self.ghostData[ent:EntIndex()];
	if (originalData == nil) then return end
	
	ent:SetRenderMode(originalData.renderMode);
	ent:SetColor(originalData.color);
	ent:SetCollisionGroup(originalData.collisionGroup);
	
	self.ghostData[ent:EntIndex()] = nil;
end 

function main:IsGhosted(ent)

	if (self.ghostData[ent:EntIndex()]) then return true end 
	return false;
end

/*
	Returns a bool deciding if an entity is in the physgunGhostList table 
*/
function main:ShouldGhostEntity(ent)
	if (self.physgunGhostList[ent:GetClass()]) then return true else return false end
end
hook.Add("smartsauce_shouldghost", "shouldghost", function(ent) return main:ShouldGhostEntity(ent) end);

/*
	Returns a bool determining if a player is inside the bounds of an entity 
*/
function main:EntityInEntityBounds(ent)

	local mins, maxs = ent:WorldSpaceAABB();
	
	for k,v in next, ents.GetAll() do 
		if (v==ent) then continue end
		if (v:IsWeapon()) then continue end
		if (self.bPropsInProps) then 
			if (!v:IsPlayer() && !v:IsNPC() && !v:IsVehicle()) then continue end 
		else 
			if (!v:IsPlayer() && !v:IsNPC() && !v:IsVehicle() && v:GetClass() != "prop_physics") then continue end 
		end
		
		local thisMins, thisMaxs = v:WorldSpaceAABB();
		
		if (v:IsPlayer() || v:GetClass() == "prop_physics") then 
			if ((v:LocalToWorld(v:OBBCenter())-ent:GetPos()):Length() < 20) then return true end 
		end
		
		if (mins:WithinAABox(thisMins, thisMaxs)) then return true end 
		if (maxs:WithinAABox(thisMins, thisMaxs)) then return true end
		if (thisMins:WithinAABox(mins, maxs)) then return true end 
		if (thisMaxs:WithinAABox(mins, maxs)) then return true end
	end
		
	return false; 
end

/*
	Returns a bool determining if an entity is inside the bounds of a ghost zone 
*/
function main:EntityInGhostZone(ent)
		
	for k,v in next, self.ghostZones do 
		
		local maxsX = math.max(v.mins.x, v.maxs.x);
		local maxsY = math.max(v.mins.y, v.maxs.y);
		local maxsZ = math.max(v.mins.z, v.maxs.z);
		
		local minsX = math.min(v.mins.x, v.maxs.x);
		local minsY = math.min(v.mins.y, v.maxs.y);
		local minsZ = math.min(v.mins.z, v.maxs.z);

		local maxVec = Vector(maxsX, maxsY, maxsZ);
		local minVec = Vector(minsX, minsY, minsZ);
		
		if (ent:GetPos():WithinAABox(minVec, maxVec)) then return k end
	end 
	return 0;
end

/*
	Adds an entity class to the physgun ghost list 
*/
function main:BlacklistEntity(ply, ent)
	
	if (!self:IsStaff(ply)) then return end
	if (ent:IsPlayer()) then return end
	if (self.physgunGhostList[ent:GetClass()] != nil) then return end 
	self.physgunGhostList[ent:GetClass()] = true;
	
	notify:NotifyPlayer(player.GetAll(), string.format(smartsauce_config.lang.blacklistNote, ent:GetClass()), 4);
	self:Save();
end 
hook.Add("smartsauce_blacklist", "blacklist", function(ply, ent) main:BlacklistEntity(ply, ent) end);

/*
	Removes an entity class from the physgun ghost list 
*/
function main:UnblacklistEntity(ply, ent)

	if (!self:IsStaff(ply)) then return end
	if (self.physgunGhostList[ent:GetClass()] == nil) then return end 
	self.physgunGhostList[ent:GetClass()] = nil;
	
	notify:NotifyPlayer(player.GetAll(), string.format(smartsauce_config.lang.unblacklistNote, ent:GetClass()), 4);
end 
hook.Add("smartsauce_unblacklist", "unblacklist", function(ply, ent) main:UnblacklistEntity(ply, ent) end);

/*
	Handles pickup of entities with physgun
*/
function main.PhysgunPickup(ply, ent)
	
	if (main.bGhostProps) then
		local allEnts = constraint.GetAllConstrainedEntities(ent);
		if (table.Count(allEnts) > main.unfreezeThreshold && !main:IsStaff(ply)) then 
			return false;
		end
		for k,v in next, constraint.GetAllConstrainedEntities(ent) do 
			
			local canTouch = true;
			if (v.CPPICanPhysgun) then 
				canTouch = v:CPPICanPhysgun(ply);
			end

			if (canTouch) then 
				if (main:ShouldGhostEntity(v)) then 
					main:GhostEntity(v);
				end 
			end
		end
	end
end
hook.Add("PhysgunPickup", "smartsauce_pickup", main.PhysgunPickup); 

/*
	Handles pickup of entities with gravity gun 
*/
function main.GravPickup(ply, ent)
	
	if (main.bGhostGravGun) then 
		if (main.bGhostProps) then 
			if (main:ShouldGhostEntity(ent)) then 
				main:GhostEntity(ent);
			end 
		end
	end
end 
hook.Add("GravGunOnPickedUp", "smartsauce_grav_pickup", main.GravPickup);

/*
	Handles dropping of entities with gravity gun 
*/
function main.GravGunOnDropped(ply, ent)

	hook.Call("PhysgunDrop", nil, ply, ent);
end 
hook.Add("GravGunOnDropped", "smartsauce_grav_drop", main.GravGunOnDropped);

/*
	Handles freezing of entities with physgun 
*/

/* Commented to avoid conflict with sandbox gamemodes (props moving about with thrusters)
function main.OnPhysgunFreeze(weapon, physobj, ent, ply)
	
	if (main.bGhostProps) then 
		timer.Simple(0.1, function()
			if (IsValid(ply) && IsValid(ent)) then
				if (main:ShouldGhostEntity(ent)) then 
					
					// Check if the entity is still being physgunned 
					local phys = ent:GetPhysicsObject();
					if (IsValid(phys)) then 
						if (phys:GetMass() == 45678) then return end
					end
					
					// Check for obstructions & Ghost zones
					local bObstructed = main:EntityInEntityBounds(ent);
					local bInGhostZone = main:EntityInGhostZone(ent);
					if (!bObstructed && !bInGhostZone) then 
						main:UnghostEntity(ent);
					elseif(bObstructed) then 
						notify:NotifyPlayer(ply, smartsauce_config.lang.obstructionNote, 4);
					elseif(bInGhostZone) then 
						notify:NotifyPlayer(ply, smartsauce_config.lang.ghostZoneNote, 4);
					end 
				end
			end 
		end);
	end
end
hook.Add("OnPhysgunFreeze", "smartsauce_drop", main.OnPhysgunFreeze);
*/

/*
	Looks for props with the same model in a small radius 
*/
function main:IsFadingDoorExploit(ent)
	
	local count = 0;
	for k,v in next, ents.FindInSphere(ent:GetPos(), 75) do 
	
		if (v:GetModel() == ent:GetModel()) then 
			count = count + 1;
		end 
	end 
	
	if (count >= self.fadingDoorThreshold) then 
		return true;
	end 
	return false;
end

/*
	Handles tool-gunning of ghosted entities 
*/
function main.CanTool(ply, tr, tool)
	
	if (main.fadingDoorTools[tool]) then // this is the fading door tool!
		if (IsValid(tr.Entity)) then 
			
			if (main:IsFadingDoorExploit(tr.Entity)) then 
				for k,v in next, ents.FindByClass("prop_physics") do
					if (v.CPPIGetOwner) then 
						if (v:CPPIGetOwner() == ply) then 
							v:Remove();
						end 
					end
				end
				notify:NotifyPlayer(player.GetAll(), string.format(smartsauce_config.lang.fadingDoorCrash, ply:Nick()), 10);
				return false;
			end
		end
	end 
	
	if (main.bNoCollide) then 
		if (tool == "nocollide") then 	
			if (IsValid(tr.Entity)) then 	
				if (main:IsGhosted(tr.Entity)) then 	
					return false;
				end
			end
		end 
	end
end 
hook.Add("CanTool", "smartsauce_cantool", main.CanTool);

/*
	Handles dropping of entities with physgun 
*/
function main.OnPhysgunDrop(ply, ent)

	if (main.bGhostProps) then 

		timer.Simple(0.1, function()
			if (IsValid(ent)) then 
			
				for k,v in next, constraint.GetAllConstrainedEntities(ent) do 
					if (IsValid(ply) && IsValid(v)) then
									
						// Run a check to see if we should bypass the unghosting code
						if (!main.bPropsInProps) then 
							local activeTool = ply:GetTool();
							local activeWep = ply:GetActiveWeapon();
							
							if (activeTool && IsValid(activeWep)) then
								if (activeTool.Mode && activeWep:GetClass() == "gmod_tool") then 
									if (main.propsInPropsIgnore[activeTool.Mode]) then 
										local inGhostZone = main:EntityInGhostZone(v);
										if (inGhostZone != 0) then 
											if (v:GetClass() == "prop_physics") then 
												v:Remove();
											end 
										else 
											main:UnghostEntity(v);
										end
										continue; // Skip the rest of the loop...
									end 
								end	
							end
						end
					
						if (main:ShouldGhostEntity(v)) then 

							// Check if the entity is still being physgunned 
							local phys = v:GetPhysicsObject();
							if (IsValid(phys)) then 
								if (phys:GetMass() == 45678) then return end
							end
								
							// Check for obstructions & Ghost zones
							local bObstructed = main:EntityInEntityBounds(v);
							local inGhostZone = main:EntityInGhostZone(v);
							if (!bObstructed && inGhostZone == 0) then 
								main:UnghostEntity(v);
							elseif(bObstructed) then 
									
								notify:NotifyPlayer(ply, smartsauce_config.lang.obstructionNote, 4);
							elseif(inGhostZone != 0) then 
								if (v:GetClass() == "prop_physics") then 
									v:Remove();
								end
								notify:NotifyPlayer(ply, smartsauce_config.lang.ghostZoneNote, 4);
							end 
						end
							
						local phys = v:GetPhysicsObject();
						if (IsValid(phys)) then 
							phys:SetVelocity(Vector(0, 0, 0));
							phys:AddAngleVelocity(-phys:GetAngleVelocity());
						end 
					end
				end
			end
		end);
	end
end
hook.Add("PhysgunDrop", "smartsauce_drop", main.OnPhysgunDrop);

/*
	Handles removal of entities 
*/
function main.RemoveEntity(ent)
	
	if (main.ghostData[ent:EntIndex()]) then 
		main.ghostData[ent:EntIndex()] = nil;
	end
end 
hook.Add("EntityRemoved", "smartsauce_remove_entity", main.RemoveEntity);

/*
	Handles adding of ghost zones with toolgun
*/
function main.AddGhostZone(ply, mins, maxs, bGod, bArrest)

	bGod = bGod || false;
	bArrest = bArrest || false;

	main.ghostZones[table.Count(main.ghostZones) + 1] = {
		mins = mins,
		maxs = maxs,
		god = bGod,
		arrest = bArrest,
	};
	
	notify:NotifyPlayer(ply, smartsauce_config.lang.ghostZoneAdded, 4);
	main:Save();
end
hook.Add("smartsauce_addghostzone", "add", main.AddGhostZone);

/*
	Handles removal of ghost zones with toolgun or menu 
*/
function main.RemoveGhostZone(ply, index)

	table.remove(self.ghostZones, index);
end
hook.Add("smartsauce_removeghostzone", "remove", main.RemoveGhostZone);

/*
	Handles arresting in ghost zones 
*/
function main.CanArrest(arrester, arrestee)

	local ghostZone = main:EntityInGhostZone(arrestee);
	if (main.ghostZones[ghostZone]) then 	
		if (main.ghostZones[ghostZone].arrest) then return false, smartsauce_config.lang.antiArrest end 
	end
end 
hook.Add("canArrest", "smartsauce_canarrest", main.CanArrest);

/*
	Disables damage from blacklisted entities 
*/
function main.EntityTakeDamage(ent, cDamageInfo)

	if (ent:IsPlayer()) then 
		// Prevent players inside god-mode ghost zones from taking damage
		local ghostZone = main:EntityInGhostZone(ent);
		if (main.ghostZones[ghostZone]) then 	
			if (main.ghostZones[ghostZone].god) then return true end 
		end
		// Prevent players inside vehicles from taking damage 
		if (!main.bInVehicleDamage) then 
			if (ent:InVehicle()) then 
				return true;
			end 
		end
	end

	if (IsValid(cDamageInfo:GetAttacker())) then 
	
		if (!main.bPropDamage) then 
			if (main:ShouldGhostEntity(cDamageInfo:GetAttacker())) then return true end 
			if (main:ShouldGhostEntity(cDamageInfo:GetInflictor())) then return true end 
		end

		if (!main.bVehicleDamage) then // Avoid vehicle damage
			if (cDamageInfo:GetAttacker():IsVehicle()) then 
				return true;
			end
			if (IsValid(cDamageInfo:GetInflictor())) then  // Check inflictor (VC MOD?)
				if (cDamageInfo:GetInflictor():IsVehicle()) then 
					return true;
				end
			end
		end

	else 
		
		if (ent:IsPlayer()) then // Avoid players getting crushed by props and vehicles
			if (cDamageInfo:GetAttacker() != NULL) then  // Check for valid entity
				if (cDamageInfo:GetAttacker().GetClass != NULL) then // Check for valid GetClass function 
					if (cDamageInfo:GetAttacker():GetClass() == "worldspawn") then  // Check for world spawn 
						if (!main.bPropDamage || !main.bVehicleDamage) then // Check if one of the applicable features are enabled
							if (ent:GetVelocity().z > -35) then return true end // Prop is falling onto ply, ply is not taking fall dmg
						end
					end 
				end
			end
		end
	end
end 
hook.Add("EntityTakeDamage", "smartsauce_damage", main.EntityTakeDamage);

/*
	Handles gravity gun punting 
*/
function main.GravGunPunt(ply, ent)
		
	return main.bGravgunPunt;
end 
hook.Add("GravGunPunt", "smartsauce_gravgun1_punt", main.GravGunPunt);

/*
	Forces the client to update and open the menu
*/
function main:OpenMenu(ply)

	local varTable = self:GenerateVariableTable();
	varTable.lagData = lag:GetData();
	
	net.Start("smartsauce_menu");
		net.WriteTable(varTable);
	net.Send(ply);
end 

/*
	Handles the chat command 
*/
function main.PlayerSay(ply, text, bTeam)
	
	if (main:IsStaff(ply)) then 
		
		local lower = string.lower(text);
		
		if (lower == smartsauce_config.menuCommand) then 
			
			main:OpenMenu(ply);
			return "";
		end
	end
end 
hook.Add("PlayerSay", "smartsauce_chat", main.PlayerSay);

/*
	Adds collision callback to all created entities
*/
_G.SmartSauce_CollisionCount = 0;
function main.EntCreated(ent)

	ent:AddCallback("PhysicsCollide", function(colData, physCollider)
		_G.SmartSauce_CollisionCount = _G.SmartSauce_CollisionCount + 1;
	end);
end 
hook.Add("OnEntityCreated", "smartsauce_spawn", main.EntCreated);

/*
	Handles anti-prop spam 
*/
function main.PlayerSpawnProp(ply, model)
	
	if (main.bAntiSpam) then 
		
		local bIgnore = false;
		local wep = ply:GetActiveWeapon();
		if (IsValid(wep)) then 
		
			if (wep.current_mode) then 
				if (main.antiSpamIgnore[wep.current_mode]) then 
					bIgnore = true;
				end 
			end 
		end 
		
		if (!bIgnore) then 
		
			if (ply.smartsauce_lastprop == nil) then 
				ply.smartsauce_lastprop = CurTime();
			end
			
			if (ply.smartsauce_lastprop > CurTime()) then 
			
				ply.smartsauce_lastprop = CurTime() + smartsauce_config.defaultAntiSpamDelay;
				notify:NotifyPlayer(ply, smartsauce_config.lang.antiSpam, 4);
				return false;
			end
		
			ply.smartsauce_lastprop = CurTime() + smartsauce_config.defaultAntiSpamDelay;
		end 
	end
end 
hook.Add("PlayerSpawnProp", "smartsauce_prespawnprop", main.PlayerSpawnProp);

/*
	Ghosts props when spawned 
*/
function main.PlayerSpawnedProp(ply, mdl, ent)
	
	if (main.bGhostProps) then 
		timer.Simple(0, function()
			
			if (!IsValid(ent)) then return end
			if (main:ShouldGhostEntity(ent)) then
				main:GhostEntity(ent);
			end
			
			hook.Call("PhysgunDrop", nil, ply, ent);
		end);
	end
end 
hook.Add("PlayerSpawnedProp", "smartsauce_spawnprop", main.PlayerSpawnedProp)

/*
	Handles physgun unfreezing 
*/
function main.CanPlayerUnfreeze(ply, ent, phys)

	if (!main.bPhysgunUnfreeze) then 
		notify:NotifyPlayer(ply, smartsauce_config.lang.physgunReloadNotAllowed, 5);
		return false;
	end
end 
hook.Add("CanPlayerUnfreeze", "smartsauce_physgunreload", main.CanPlayerUnfreeze);

/*
	Receives the edit message from clients 
*/
function main.ReceiveEdit(len, ply)

	if (!main:IsStaff(ply)) then return end // Skiddy stopper 
	
	local actionData = net.ReadTable();
	
	if (actionData.action == "add_blacklist") then 
		if (actionData.data.class == nil) then return end 
		
		main.physgunGhostList[actionData.data.class] = true;
		notify:NotifyPlayer(ply, smartsauce_config.lang.savedChanges, 4);
		main:Save();
	
	elseif (actionData.action == "remove_blacklist") then 
		if (actionData.data.class == nil) then return end
		
		if (main.physgunGhostList[actionData.data.class]) then 
			main.physgunGhostList[actionData.data.class] = nil;
			notify:NotifyPlayer(ply, smartsauce_config.lang.savedChanges, 4);
			main:Save();
		end
		
	elseif(actionData.action == "remove_ghostzone") then 
		if (actionData.data.index == nil) then return end
		
		table.remove(main.ghostZones, actionData.data.index);
		notify:NotifyPlayer(ply, smartsauce_config.lang.savedChanges, 4);
		main:Save();
		
	elseif(actionData.action == "main_save") then 

		if (actionData.data.bGhostProps == nil) then return end
		if (actionData.data.bPropDamage == nil) then return end
		if (actionData.data.bAntiCrash == nil) then return end
		if (actionData.data.bPhysgunUnfreeze == nil) then return end

		main.bGhostProps = actionData.data.bGhostProps;
		main.bPropDamage = actionData.data.bPropDamage;
		main.bAntiCrash = actionData.data.bAntiCrash;
		main.bNoCollide = actionData.data.bNoCollide;
		main.bVehicleDamage = actionData.data.bVehicleDamage;
		main.bGravgunPunt = actionData.data.bGravgunPunt;
		main.bDecalClean = actionData.data.bDecalClean;
		main.bPhysgunUnfreeze = actionData.data.bPhysgunUnfreeze;
		main.bAntiSpam = actionData.data.bAntiSpam;
		main.bPropsInProps = actionData.data.bPropsInProps;
		main.bGhostGravGun = actionData.data.bGhostGravGun;
		main.bInVehicleDamage = actionData.data.bInVehicleDamage;
		notify:NotifyPlayer(ply, smartsauce_config.lang.savedChanges, 4);
		
		lag:SetEnabled(main.bAntiCrash);
		
		main:Save();
		
	elseif(actionData.action == "graph_save") then 
	
		if (actionData.data.cleanupThreshold == nil) then return end 
		
		main.cleanupThreshold = actionData.data.cleanupThreshold;
		main.unfreezeThreshold = actionData.data.unfreezeThreshold;
		main.fadingDoorThreshold = actionData.data.fadingDoorThreshold;
		lag:SetCleanupThreshold(main.cleanupThreshold);
		lag:SetUnfreezeThreshold(main.unfreezeThreshold);
		main:Save();
		
	elseif(actionData.action == "save") then 
		
		main:Save();
		notify:NotifyPlayer(ply, smartsauce_config.lang.savedChanges, 4);
	end
	
	main:OpenMenu(ply);
end 
net.Receive("smartsauce_edit", main.ReceiveEdit);
	
/*
	Called when a crash is detected 
*/
function main.Crash()
	notify:NotifyPlayer(player.GetAll(), smartsauce_config.lang.crashPrevented, 5);
end 
hook.Add("smartsauce_crash", "crash", main.Crash);

/*
	Called when stacker spam is detected
*/

function main.StackerCrash(minge)
	
	notify:NotifyPlayer(player.GetAll(), string.format(smartsauce_config.lang.unfreezeCrash, minge:Nick()), 10);
end
hook.Add("smartsauce_stackercrash", "stacker_crash", main.StackerCrash);

/*	
	Cleans up decals 
*/
function main.CleanupDecals()

	if (main.bDecalClean) then 
	
		net.Start("smartsauce_decal");
		net.Broadcast();
	end
end 
timer.Create("smartsauce_decal_cleanup", smartsauce_config.decalCleanInterval, 0, main.CleanupDecals);

/*
	Initializes the script after all entities have loaded 
*/
function main.Init()

	main:Load();
	lag:Init();
	lag:SetCleanupThreshold(main.cleanupThreshold);
	lag:SetUnfreezeThreshold(main.unfreezeThreshold);
	if (main.bAntiCrash) then 
		lag:SetEnabled(true);
	end
	propertiesPlugin:Init();
end 
hook.Add("InitPostEntity", "smartsauce_init", main.Init);