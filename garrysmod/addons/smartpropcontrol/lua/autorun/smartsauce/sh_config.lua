//
/*
	Configuration
	3/2/2018
	Smart Like My Shoe 
*/

local config = {};

/*
	Version
*/
config.version = "1.5";

/*
	Persistence
*/
config.fileName = "smartsauce_data.txt";

/*
	Staff 
	ULX usergroups
*/
config.staff 						= {};
config.staff["admin"] 				= true;
config.staff["superadmin"] 			= true;
config.staff["owner"] 				= true;
config.staff["founder"] 			= true;
config.staff["developer"] 			= true;

/*
	Ghosting 
*/
config.ghostColor 					= Color(30, 30, 30, 200);

/*
	Chat Commands
*/
config.menuCommand					= "!spc";

/*
	Decal Cleaner 
*/
config.decalCleanInterval 			= 120; // Clean decals every 120 seconds

/*
	Anti-Spam
*/
config.defaultAntiSpamDelay			= 0.5; // Determines how long a player must wait to spawn another prop

/*
	Anti-Crash Lag Detection 
*/
config.defaultCleanupThreshold		= 125; 	// Determines when the anti-crash routine is executed
config.defaultUnfreezeThreshold		= 15; 	// Determines how many constrained props can be unfreezed at once
config.defaultFadingDoorThreshold	= 10;   // Determines how many fading doors can be placed inside a small radius
config.physicsEvaulationInterval 	= 3; 	// 3 Seconds
config.graphYAxisInterval 			= 100;

/*
	Language
	This stuff is here to help you translate the addon yourself 
*/
config.lang = {};

config.lang.blacklist 				= "SPC Blacklist";
config.lang.unblacklist 			= "SPC Unblacklist";
config.lang.menuTitle 				= "Smart Prop Control Panel";
config.lang.tabTitle 				= "Config";
config.lang.tab2Title 				= "Blacklist";
config.lang.tab3Title 				= "Ghost Zones";
config.lang.tab4Title				= "Lag";

config.lang.blacklistNote			= "%s blacklisted!";
config.lang.unblacklistNote			= "%s unblacklisted!";

config.lang.ghostZoneAdded			= "Ghost zone created!";

config.lang.savedChanges			= "Saved Changes!";
config.lang.ghostZoneNote			= "Prop ghosting is enforced here.";
config.lang.obstructionNote			= "Your prop is obstructed!";

config.lang.save					= "Save";
config.lang.add						= "Add";
config.lang.remove					= "Remove";
config.lang.antiCrash				= "Anti-Crash Lag Detection";
config.lang.propDamage				= "Allow Blacklisted Entity Damage";
config.lang.propGhosting 			= "Prop Ghosting";
config.lang.nocollide				= "No-Collide Ghosted Props With Everything";
config.lang.vehicleDamage			= "Allow Vehicle Damage";
config.lang.gravPunt				= "Allow Gravity Gun Punting";
config.lang.decalClean 				= "Automatically Clean Up Decals";
config.lang.physgunReload			= "Allow Physgun Reload Unfreeze";
config.lang.antiPropSpam			= "Prop Spam Prevention";
config.lang.propsInProps			= "Allow props inside other props";
config.lang.ghostOnGravGun			= "Ghost on gravity gun pickup";
config.lang.damageInVehicles		= "Allow damage to players inside vehicles";

config.lang.disableGhostRendering 	= "Disable Ghost-Zone Rendering";
config.lang.enableGhostRendering	= "Enable Ghost-Zone Rendering";
config.lang.enterEntityClass		= "Enter Entity Class";

config.lang.crashPrevented			= "Crash prevented!";
config.lang.physgunReloadNotAllowed	= "Physgun Reload Unfreezing is disabled!";

config.lang.time 					= "Time";
config.lang.collisionsPerSecond		= "Avg Physics Collisions / s";
config.lang.refresh					= "Refresh";

config.lang.antiCrashThreshold		= "Anti-Crash Threshold";
config.lang.crashWarning			= "CRASH WARNING!";
config.lang.healthyLag				= "HEALTHY";

config.lang.unfreezeCrash			= "%s is attempting to unfreeze many props!";
config.lang.unfreezeCrashThreshold	= "Unfreeze-Crash Threshold";
config.lang.fadingDoorCrash			= "%s is attempting the fading door crash exploit!";
config.lang.fadingDoorCrashThreshold = "Fading-Door Crash Threshold";

config.lang.antiSpam				= "You must wait before spawning another prop!";
config.lang.antiArrest				= "Arresting is forbidden here!";

config.lang.zone 					= "Zone: ";

/*
	DO NOT TOUCH
*/
smartsauce_config = config;