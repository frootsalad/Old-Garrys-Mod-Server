--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
DarkRP.createEntity("Repair Kit 100%", {
    ent = "vc_pickup_healthkit_100",
    model = "models/vcmod/vcmod_toolbox.mdl",
    price = 10000,
    max = 1,
    cmd = "buyrepairkit",
    allowed = TEAM_CAR_MECHANIC
})

DarkRP.createEntity("Repair Kit 25%", {
    ent = "vc_pickup_healthkit_25",
    model = "models/vcmod/vcmod_wrenchset.mdl",
    price = 3000,
    max = 1,
    cmd = "buyrepairkit25",
    allowed = TEAM_CAR_MECHANIC
})

DarkRP.createEntity("Repair Kit 10%", {
    ent = "vc_pickup_healthkit_10",
    model = "models/vcmod/vcmod_wrench.mdl",
    price = 1500,
    max = 1,
    cmd = "buyrepairkit10",
    allowed = TEAM_CAR_MECHANIC
})

DarkRP.createEntity("Radio", {
    ent = "rp_radio",
    model = "models/props_lab/citizenradio.mdl",
    price = 1500,
    max = 1,
    cmd = "buyradio",
    allowed = TEAM_DJ
})

DarkRP.createEntity("Microphone", {
    ent = "rp_radio_microphone",
    model = "models/mic.mdl",
    price = 1500,
    max = 1,
    cmd = "buymic",
    allowed = TEAM_DJ
})
