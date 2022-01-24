 
DFFP = DFFP or {}  
DFFP.Config = {}
DFFP.Config.toolAccess = { --Which usergroups have access to the tool.

	"admin",
	"superadmin",
}
DFFP.Config.espIgnore = { --Ignore world models in downtown so ESP doesn't look like garbage.
	"models/props_c17/door01_left.mdl",
	"models/props_interiors/lights_florescent01a.mdl",
	"models/props_wasteland/prison_sink001a.mdl",
	"models/props_wasteland/prison_toilet01.mdl",
	"models/props_c17/furniturefridge001a.mdl",
	"models/props_doors/door03_slotted_left.mdl",
	"models/props_junk/trashdumpster01a.mdl",
	"models/props_lab/freightelevatorbutton.mdl",
}
DFFP.Config.NotifyBlockedSpawn = true -- Notifys the player if the blocked model spawning was left enabled when putting their tool away.