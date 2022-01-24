//
/*
	Serverside Lag detection 
	Smart Like My Shoe
	3/3/2018
	
	I measure the physics collisions in sv_main, no reason to have two EntityCreated hooks 
*/

local lag = {
	
	avgCollisions = 0,
	collisionInterval = 5,
	cleanupThreshold = 250,
	data = {},
	
	bEnabled = false,
	lagAccumulator = 0,
	lastCleanup = 0,
	unfreezeThreshold = 15,
	lastPlyUnfreeze = {},
};

/*
	Sets enabled 
*/
function lag:SetEnabled(bool)
	
	self.bEnabled = bool;
	if (bool) then 
		_G.SmartSauce_CollisionCount = 0;
	end
end

/*
	Gets the lag data table 
*/
function lag:GetData()
	return self.data;
end

/*
	Sets the cleanup threshold
*/
function lag:SetCleanupThreshold(threshold)
	self.cleanupThreshold = threshold;
end

/*
	Sets the unfreeze threshold 
*/
function lag:SetUnfreezeThreshold(threshold)
	self.unfreezeThreshold = threshold;
end

/*
	Cleans up moving props 
*/
function lag:CleanupRoutine()
	
	if (self.lastCleanup < CurTime()) then 
	
		for k,v in next, ents.FindByClass("prop_physics") do 
			
			if (!IsValid(v)) then continue end 
			if (v.CPPIGetOwner) then 
				//print(v:CPPIGetOwner());
				if (v:CPPIGetOwner() == nil) then // this is a world prop 
					continue;
				end 
			end
			
			local phys = v:GetPhysicsObject();
			if (IsValid(phys)) then 
				if (phys:IsMotionEnabled()) then 
		
					for a,b in next, constraint.GetAllConstrainedEntities(v) do 
						if (IsValid(b)) then 
							//b:Remove();
							hook.Call("smartsauce_ghostentity", nil, b);
						end
					end 
				end
			end
		end
		
		hook.Call("smartsauce_crash", nil);
		self.lastCleanup = CurTime() + 0.5;
	end
end

/*
	Cleans up all props of a specific player 
*/
function lag:TargetedCleanupRoutine(ply)

	for k,v in next, ents.FindByClass("prop_physics") do
		if (v.CPPIGetOwner) then 
			if (v:CPPIGetOwner() == ply) then 
			
				hook.Call("smartsauce_ghostentity", nil, v);
			end 
		end
	end
end 

/*
	Checks if the threshold has been broken
*/
function lag:CheckThreshold()

	if (self.avgCollisions > self.cleanupThreshold) then 
		self.lagAccumulator = self.lagAccumulator + 1;
		if (self.lagAccumulator >= 2) then // Run cleanup routine
			
			self:CleanupRoutine();
			self.lagAccumulator = 0;
		end 
	elseif(self.lagAccumulator > 0) then 
		self.lagAccumulator = 0;
	end
end

/*
	Evaluates physics collisions every collisionInterval seconds
*/
function lag.Evaluate()
	
	if (!lag.bEnabled) then return end
	
	lag.avgCollisions = _G.SmartSauce_CollisionCount / lag.collisionInterval;
	local bDataFull = true;
	// Find a spot to put some data in ascending order
	for i = 1, 20 do 
		if (lag.data[i] != nil) then continue end
		lag.data[i] = lag.avgCollisions;
		bDataFull = false;
		break;
	end
	
	if (bDataFull) then // Reset the data, set the first entry to the avg collisions 
		lag.data = {};
		lag.data[1] = lag.avgCollisions;
	end
	
	_G.SmartSauce_CollisionCount = 0;
	lag:CheckThreshold();
end 

/*
	Prevents stacker physics loop 
*/
function lag.CanPlayerUnfreeze(ply, ent, phys)
	
	if (lag.bEnabled) then 
	
		if (lag.lastPlyUnfreeze[ply:SteamID()] == nil) then 
			lag.lastPlyUnfreeze[ply:SteamID()] = 0;
		end
		
		if (lag.lastPlyUnfreeze[ply:SteamID()] < CurTime()) then // Check if the player is allowed to unfreeze entities
	
			local constrainedEnts = constraint.GetAllConstrainedEntities(ent);
			
			local totalEnts = 0;
			local entsCounted = {};
			
			for k,v in next, constrainedEnts do 
				for a,b in next, constraint.GetAllConstrainedEntities(v) do
					
					if (entsCounted[b:EntIndex()]) then continue end 
					
					entsCounted[b:EntIndex()] = true;
					totalEnts = totalEnts + 1;
				end
			end
			
			if (totalEnts > lag.unfreezeThreshold) then 
				
				lag.lastPlyUnfreeze[ply:SteamID()] = CurTime() + 1; // unfreeze spam detected, start blocking further unfreeze attempts
				hook.Call("smartsauce_stackercrash", nil, ply);
				lag:TargetedCleanupRoutine(ply);
				return false;
			end
		else // At this point the player is spamming unfreeze
			return false;
		end
	end
end
hook.Add("CanPlayerUnfreeze", "smart_antilag_CanPlayerUnfreeze", lag.CanPlayerUnfreeze);

/*
	Initializes the plugin 
*/
function lag:Init()
	self.collisionInterval = smartsauce_config.physicsEvaulationInterval;
	self.cleanupThreshold = smartsauce_config.defaultCleanupThreshold;
	timer.Create("smartsauce_evaluatephysics",  self.collisionInterval, 0, self.Evaluate);
end


return lag;