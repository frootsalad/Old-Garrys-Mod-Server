local MODULE = bLogs:Module()

MODULE.Category = "Sandbox"
MODULE.Name     = "Effects"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PlayerSpawnedEffect","spawnedeffect",function(ply,model)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " spawned " .. bLogs:Highlight(model))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Sandbox"
MODULE.Name     = "NPCs"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PlayerSpawnedNPC","spawnednpc",function(ply,ent)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " spawned NPC " .. bLogs:FormatEntity(ent))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Sandbox"
MODULE.Name     = "Props"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PlayerSpawnedProp","spawnedprop",function(ply,model)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " spawned prop " .. bLogs:Highlight(model))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Sandbox"
MODULE.Name     = "Ragdolls"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PlayerSpawnedRagdoll","spawnedragdoll",function(ply,model)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " spawned ragdoll " .. bLogs:Highlight(model))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Sandbox"
MODULE.Name     = "SENTs"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PlayerSpawnedSENT","spawnedsent",function(ply,ent)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " spawned SENT " .. bLogs:FormatEntity(ent))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Sandbox"
MODULE.Name     = "SWEPs"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PlayerSpawnedSWEP","spawnedswep",function(ply,ent)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " spawned SWEP " .. bLogs:FormatEntity(ent))
end)

bLogs:AddModule(MODULE)

local MODULE = bLogs:Module()

-----------------------------------------------------------------

MODULE.Category = "Sandbox"
MODULE.Name     = "Vehicles"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PlayerSpawnedVehicle","spawnedswep",function(ply,ent)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " spawned vehicle " .. bLogs:FormatEntity(ent))
end)

bLogs:AddModule(MODULE)
