//
/*
	Plugin - Properties
	Smart Like My Shoe
	3/2/2018
*/

local plugin = {};

/*
	Adds properties to the context menu 
*/
function plugin:Init()
	
	
	properties.Add("smartsauce_blacklist", { 	// Thanks to gmod wiki
		MenuLabel = smartsauce_config.lang.blacklist, 			// Name to display on the context menu
		Order = 10, 							// The order to display this property relative to other properties
		MenuIcon = "icon16/delete.png", 			// The icon to display next to the property

		Filter = function(self, ent, ply) 		// A function that determines whether an entity is valid for this property
			if (!IsValid(ent)) then return false end
			if (ent:IsNPC()) then return false end
			return !ent:IsPlayer();
		end,
		Action = function(self, ent) 			// The action to perform upon using the property ( Clientside )

			self:MsgStart();
				net.WriteEntity(ent);
			self:MsgEnd();
		end,
		Receive = function(self, length, ply) // The action to perform upon using the property ( Serverside )
			local ent = net.ReadEntity()
			if (!self:Filter(ent, ply)) then return end
			hook.Call("smartsauce_blacklist", nil, ply, ent);
		end
	});
	
	properties.Add("smartsauce_unblacklist", { 
		MenuLabel = smartsauce_config.lang.unblacklist, 	
		Order = 9, 							
		MenuIcon = "icon16/accept.png", 		

		Filter = function(self, ent, ply) 		
			if (!IsValid(ent)) then return false end
			if (ent:IsNPC()) then return false end
			return !ent:IsPlayer();
		end,
		Action = function(self, ent) 			

			self:MsgStart();
				net.WriteEntity(ent);
			self:MsgEnd();
		end,
		Receive = function(self, length, ply) 
			local ent = net.ReadEntity();
			if (!self:Filter(ent, ply)) then return end
			hook.Call("smartsauce_unblacklist", nil, ply, ent);
		end
	});
end


return plugin;